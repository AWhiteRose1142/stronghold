module( "Gesture", package.seeall )

--================================================
-- Gesture idea:
-- When left mouse down is called, start a timer.
-- let timer compare mouse location.
-- store type of movement somewhere.
-- if movements match up to set pattern,
-- execute the right function for that pattern.
--================================================

-- Gesture types
UP         = 1
DOWN       = 2
LEFT       = 3
RIGHT      = 4
UP_LEFT    = 5
UP_RIGHT   = 6
DOWN_LEFT  = 7
DOWN_RIGHT = 8

function Gesture:initialize()
  
  -- Register callbacks
  if MOAIInputMgr.device.pointer then
    MOAIInputMgr.device.mouseLeft:setCallback(
      function( isMouseDown )
        -- Mouse down
        if MOAIInputMgr.device.mouseLeft:isDown() then Gesture:onMouseDown() end
        -- Mouse up
        if MOAIInputMgr.device.mouseLeft:isUp() then Gesture:onMouseUp() end
      end
    )
  end
end

--======================================================
-- Update function
--======================================================

function Gesture:update()
  if MOAIInputMgr.device.mouseLeft:isDown() then
    if Gesture.line ~= nil then
      local newX, newY = Gesture:getMouseLocation( Game.layers.active )
      --print( "tracking a gesture" )
      Gesture:trackGesture( newX, newY )
    end
  end
end

--======================================================
-- Event handlers, for mouse & touch
--======================================================

function Gesture:onMouseDown()
  --Gesture:trackSwipe()
  local newX, newY = Gesture:getMouseLocation( Game.layers.active )
  
  if Gesture.line == nil then
    print( "making a new line" )
    Gesture.line = Line:new( { newX, newY }, Game.layers.user )
  else
    print( "tracking a gesture" )
    Gesture:trackGesture( newX, newY )
  end
  
end

function Gesture:onMouseUp()
  print( "mouse is up, stopping gesture tracking" )
  local mouseX, mouseY = Gesture:getMouseLocation( Game.layers.active )
  local n = table.getn( Gesture.gestureTable )
  
  Gesture:determineCombo()
  Gesture.line:destroy()
  Gesture.line = nil
  Gesture.gestureTable = nil
  
  if n > 1 then
    Level:spawnBolts( { mouseX, mouseY } )
    for key, entity in pairs( Level:getEntitiesNearPos( { mouseX, -120 }, { 40, 40 } ) ) do
      if entity.electrocute ~= nil then
        entity:electrocute()
      end
    end
  end
end

--======================================================
-- Gesture detection logic
--======================================================

function Gesture:trackGesture( newX, newY )
  --check of er een table met gesture types is
  if self.gestureTable == nil then
    self.gestureTable = {}
    oldX, oldY = unpack( self.line:getPoints()[1] )
    local direction = Gesture:getDirection( newX, newY, oldX, oldY )
    Gesture:printDirection( direction )
    table.insert( self.gestureTable, direction )
    self.line:addPoint( { newX, newY } )
  else
    local direction = Gesture:getDirection( newX, newY, oldX, oldY )
    if direction == self.gestureTable[ table.getn( self.gestureTable ) ] then
      self.line:setLastPoint( { newX, newY } )
    else
      Gesture:printGestureTable()
      table.insert( self.gestureTable, direction )
      self.line:addPoint( { newX, newY } )
    end
  end
  
end

function Gesture:getDirection( newX, newY, oldX, oldY )
  -- Get the difference between the new and old position
  local x = newX - oldX
  local y = newY - oldY
  
  -- Normalize x & y
  local length = math.sqrt( (x*x) + (y*y) )
  x = x / length
  y = y / length
  
  -- Get a rotation
  local rotation = math.deg( math.atan2( y, x ) )
  if rotation < 0 then rotation = 360 + rotation end -- this is to make sure we always get position degrees
  
  local vertDir = nil
  local horDir = nil
  
  if rotation >= 338 and rotation <= 22  then return UP         end
  if rotation >= 23  and rotation <= 67  then return UP_RIGHT   end
  if rotation >= 68  and rotation <= 112 then return RIGHT      end
  if rotation >= 123 and rotation <= 157 then return DOWN_RIGHT end
  if rotation >= 158 and rotation <= 203 then return DOWN       end
  if rotation >= 204 and rotation <= 248 then return DOWN_LEFT  end
  if rotation >= 249 and rotation <= 293 then return LEFT       end
  if rotation >= 294 and rotation <= 337 then return UP_LEFT    end
  
  if rotation < 0 then print( "failed to get a rotation" )      end
  
end

function Gesture:determineCombo()
  
end

function Gesture:printGestureTable()
  for key, dir in pairs( self.gestureTable ) do
    if dir == UP then print( "UP" ) end
    if dir == DOWN then print( "DOWN" ) end
    if dir == LEFT then print( "LEFT" ) end
    if dir == RIGHT then print( "RIGHT" ) end
    if dir == UP_RIGHT then print( "UP_RIGHT" ) end
    if dir == UP_LEFT then print( "UP_LEFT" ) end
    if dir == DOWN_RIGHT then print( "DOWN_RIGHT" ) end
    if dir == DOWN_LEFT then print( "DOWN_LEFT" ) end
  end
end

function Gesture:printDirection( gesture )
  if gesture == UP then print( "UP" ) end
  if gesture == DOWN then print( "DOWN" ) end
  if gesture == LEFT then print( "LEFT" ) end
  if gesture == RIGHT then print( "RIGHT" ) end
  if gesture == UP_RIGHT then print( "UP_RIGHT" ) end
  if gesture == UP_LEFT then print( "UP_LEFT" ) end
  if gesture == DOWN_RIGHT then print( "DOWN_RIGHT" ) end
  if gesture == DOWN_LEFT then print( "DOWN_LEFT" ) end
end

function Gesture:click()
  -- calls if IsMouseDown
  clickEntity = Gesture:pickEntity(Gesture:getMouseLocation(Game.layers.active))
  if(clickEntity ~= nil) then
    --clickEntity:action()
    print "entity attacks"
  end
end

-- Picks the entity at coordinates x & y
function Gesture:pickEntity( x, y )
  local obj = Game.partitions.active.propForPoint( Game.partitions.active, Gesture:getMouseLocation(Game.layers.active))
  for key, entity in pairs(Level.entities) do
    if entity.prop == obj then
      return entity
    end
  end
  return nil
end

--only handles mouse location for now.  if you pass in a layer, this will return
--in the layer's coordinate system
function Gesture:getMouseLocation( layer )
  if layer == nil then
    return MOAIInputMgr.device.pointer:getLoc ()
  else
    return layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc ())
  end
end

function Gesture:destroy()
  if Gesture.line ~= nil then Gesture.line:destroy() end
  Gesture.line = nil
  Gesture.gestureTable = nil
end