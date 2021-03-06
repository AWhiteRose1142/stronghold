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

function Gesture:initialize( layers, partitions )
  
  self.layers = layers
  self.partitions = partitions
  self.initialized = true
  self.archerControl = false
  self.archer = nil
  
end

--======================================================
-- Update function
--======================================================

function Gesture:update()
  if InputManager:isDown() then
    if Gesture.line ~= nil then
      local newX, newY = Gesture:getMouseLocation( self.layers.active )
      if Gesture.archerControl == true then
        Gesture:aimArcher( newX, newY )
      else
        Gesture:trackGesture( newX, newY )
        Gesture.prevLoc = { newX, newY }
      end
    end
  end
end

--======================================================
-- Event handlers, for mouse & touch
--======================================================

function Gesture:onMouseDown()
  local newX, newY = Gesture:getMouseLocation( self.layers.active )
  
  if Gesture:checkArcherControl( newX, newY ) == true then return end
  
  if Gesture.line == nil and self.archerControl == false then
    Gesture.line = Line:new( { newX, newY }, self.layers.user )
    Gesture.gestureTable = {}
  end
  
end

function Gesture:onMouseUp()
  --print( "Gesture mouse up!" )
  if self.line == nil then
    print( "no line registered" )
    return
  end
  
  -- Checken of we de archer aan het richten zijn
  if self.archerControl == true then
    Gesture:endArcherAim()
    return
  end
  
  -- Geen gesture porberen te tracken als deze niet ver genoeg is.
  newX, newY = Gesture:getMouseLocation( Gesture.layers.active )
  lastX, lastY = unpack( self.line.points[ table.getn( self.line.points ) - 1 ] )
  --print( "lastPos: " .. lastX .. " " .. lastY .. " newPos: " .. newX .. " " .. newY .. " distance: " .. distance( { lastX, lastY }, { newX, newY } ) )
  if 
    table.getn( Gesture.gestureTable ) < 1 and 
    distance( { lastX, lastY }, { newX, newY } ) < 20 
  then
    Gesture.line:destroy()
    Gesture.line = nil
    Gesture.gestureTable = nil
    return
  end
  
  local direction = Gesture:getDirection( { newX, newY }, { lastX, lastY } )
  table.insert( Gesture.gestureTable, direction )
  Gesture:determineCombo(  )
  Gesture.line:destroy()
  Gesture.line = nil
  Gesture.gestureTable = nil
end

function Gesture:determineCombo( )
  Gesture:printGestureTable()
  
  local startX, startY = unpack( Gesture.line.points[1] )
  local mouseX, mouseY = Gesture:getMouseLocation( self.layers.active )
  local n = table.getn( Gesture.gestureTable )
  
  if Player.progress.lightning and Player.progress.mana >= 60 and Gesture:checkLightning() then
    Player.progress.mana = Player.progress.mana - 60
    HUD.manacost:setString("-60")
    Level:spawnBolts( { mouseX, mouseY } )
    for key, entity in pairs( Level:getEntitiesNearPos( { mouseX, -120 }, { 40, 40 } ) ) do
      if entity.electrocute ~= nil then
        entity:electrocute()
      end
    end
  end
  
  if Player.progress.fireBall and Player.progress.mana >= 15 and Gesture:checkFireball() then
    --print( "casting fireball" )
    Player.progress.mana = Player.progress.mana - 15
    HUD.manacost:setString("-15")
    direction = normalize( mouseX - startX, mouseY - startY )
    Fireball:new( { startX, startY }, Level.layers.active, direction )
  elseif Player.progress.iceBolt and Player.progress.mana >= 50 and Gesture:checkIceBolt() then
    --print( "raining ice" )
    HUD.manacost:setString("-35")
    Player.progress.mana = Player.progress.mana - 35
    for i = 1, 16 do
      x = mouseX + math.random( -48, 48 )
      IceBolt:new( { x, 260 }, Level.layers.active )
    end
  end
end

function Gesture:aimArcher( x, y )
  Gesture.line.points[2] = { x, y }
  local sx, sy = unpack( self.line.points[1] )
  sx = x - sx
  sy = y - sy
  --print("rotation = " .. getRotationFrom( sx, sy ) )
  self.archer.aim = getRotationFrom( sx, sy )
end

function Gesture:endArcherAim()
  self.archerControl = false
  self.line:destroy()
  self.line = nil
  self.archer = nil
end

--======================================================
-- Gesture detection logic
--======================================================

function Gesture:trackGesture( newX, newY )
  
  -- de lijn heeft hier ten minste een punt.
  -- de lijn heeft telkens een punt meer dan het aantal gestures in de gestureTable
  local pointN = table.getn( Gesture.gestureTable ) + 2
  Gesture.line.points[pointN] = { newX, newY }
  
  absDist = math.abs( distance( Gesture.line.points[pointN - 1], Gesture.line.points[pointN] ) )
  if absDist > 30 then
    -- Ok, enough distance! now we want a direction
    local direction = Gesture:getDirection( { newX, newY }, Gesture.prevLoc )
    local gestureN = table.getn( Gesture.gestureTable )
    if gestureN < 1 then
      -- Gesture table heeft nog geen directions, voeg de eerste toe.
      table.insert( Gesture.gestureTable, direction )
    elseif Gesture.gestureTable[gestureN] ~= direction then
      table.insert( Gesture.gestureTable, direction )
    end
  end
  
end

function Gesture:getDirection( new, old )
  -- Get the difference between the new and old position
  local x = new[1] - old[1]
  local y = new[2] - old[2]
  
  -- Normalize x & y
  local length = math.sqrt( (x*x) + (y*y) )
  x = x / length
  y = y / length
  
  -- Get a rotation
  local rotation = math.deg( math.atan2( y, x ) )
  if rotation < 0 then rotation = 360 + rotation end -- this is to make sure we always get positive degrees
  
  local vertDir = nil
  local horDir = nil
  
  if rotation >= 338 and rotation <= 22  then return RIGHT end
  if rotation >= 23  and rotation <= 67  then return UP_RIGHT end
  if rotation >= 68  and rotation <= 112 then return UP end
  if rotation >= 123 and rotation <= 157 then return UP_LEFT end
  if rotation >= 158 and rotation <= 203 then return LEFT end
  if rotation >= 204 and rotation <= 248 then return DOWN_LEFT end
  if rotation >= 249 and rotation <= 293 then return DOWN end
  if rotation >= 294 and rotation <= 337 then return DOWN_RIGHT end
  
  if rotation < 0 then print( "failed to get a rotation" )      end
  print( rotation )
  
end

function Gesture:printGestureTable()
  local string = "table: "
  for key, dir in pairs( self.gestureTable ) do
    if dir == UP then string =  string .. "UP " end
    if dir == DOWN then string =  string .. "DOWN " end
    if dir == LEFT then string =  string .. "LEFT " end
    if dir == RIGHT then string =  string .. "RIGHT " end
    if dir == UP_RIGHT then string =  string .. "UP_RIGHT " end
    if dir == UP_LEFT then string =  string .. "UP_LEFT " end
    if dir == DOWN_RIGHT then string =  string .. "DOWN_RIGHT " end
    if dir == DOWN_LEFT then string =  string .. "DOWN_LEFT " end
  end
  print( string )
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
  clickEntity = Gesture:pickEntity(Gesture:getMouseLocation(self.layers.active))
  if(clickEntity ~= nil) then
    --clickEntity:action()
    print "entity attacks"
  end
end

-- Picks the entity at coordinates x & y
function Gesture:pickEntity( x, y )
  local obj = self.partitions.active.propForPoint( self.partitions.active, Gesture:getMouseLocation(self.layers.active))
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
    return InputManager:getPointerLoc()
  else
    return layer:wndToWorld( InputManager:getPointerLoc() )
  end
end

--====================================================
-- Functions that check for the right attack gesture
--====================================================

function Gesture:checkArcherControl( x, y )
  -- do we have an archer near?
  local entities = Level:getEntitiesNearPos( { x, y }, { 25, 30 } )
  if table.getn( entities ) < 1 then return false end
  
  local archers = {}
  for k, v in pairs( entities ) do
    if v.type == "archer" then table.insert( archers, v ) end
  end
  if table.getn( archers ) < 1 then return false end
  
  local archer = nil
  for k, v in pairs( archers ) do
    if archer == nil then 
      archer = v 
    elseif math.abs( distance( {x,y}, v:getPosition() ) ) < math.abs( distance( {x,y}, archer:getPosition() ) ) then
      archer = v
    end
  end
  
  -- NOW we're sure we have the right archer.
  self.archerControl = true
  self.archer = archer
  Gesture.line = Line:new( { x, y }, self.layers.user )
  print( "archer selected" )
  return true
end

function Gesture:checkFireball()
  pass = true
  for key, direction in pairs( Gesture.gestureTable ) do
    if direction ~= RIGHT and direction ~= DOWN_RIGHT then
      pass = false
    end
  end
  return pass
end

function Gesture:checkLightning()
  local gesture1 = { DOWN, DOWN_RIGHT, DOWN_LEFT }
  local gesture2 = { RIGHT, UP_RIGHT, DOWN_RIGHT, LEFT, UP_LEFT, DOWN_LEFT }
  local gesture3 = { DOWN, DOWN_RIGHT, DOWN_LEFT }
  
  for key, g1 in pairs( gesture1 ) do
    for key, g2 in pairs( gesture2 ) do
      for key, g3 in pairs( gesture3 ) do
        if Gesture:requireAllFrom( { g1, g2, g3 }, Gesture.gestureTable ) then return true end
      end
    end
  end
  return false
end

function Gesture:checkIceBolt()
  if table.getn( Gesture.gestureTable ) < 1 then return false end
  for key, direction in pairs( Gesture.gestureTable ) do
    if direction ~= DOWN then
      return false
    end
  end
  return true
end

function Gesture:requireOneFrom( multiple, gesture )
  for key, req in pairs( multiple ) do
    if gesture == req then return true end
  end
  return false
end

function Gesture:requireAllFrom( test, material )
  if table.getn( test ) > table.getn( material ) then return false end
  
  for i = 1, table.getn( test ) do
    if test[i] ~= material[i] then return false end
  end
  return true
end

function Gesture:destroy()
  if Gesture.line ~= nil then Gesture.line:destroy() end
  Gesture.line = nil
  Gesture.gestureTable = nil
  Gesture.initialized = false
end