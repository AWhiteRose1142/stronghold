module( "Gesture", package.seeall )

--================================================
-- Gesture idea:
-- When left mouse down is called, start a timer.
-- let timer compare mouse location.
-- store type of movement somewhere.
-- if movements match up to set pattern,
-- execute the right function for that pattern.
--================================================

function Gesture:initialize()
  --checks for mouseclick
  if MOAIInputMgr.device.pointer then
    MOAIInputMgr.device.mouseLeft:setCallback(
    function(isMouseDown)
      if MOAIInputMgr.device.mouseLeft:isDown() then
        Gesture:trackSwipe()
      end
      -- Just for clicks
      if MOAIInputMgr.device.mouseLeft:isUp() then
        local mouseX, mouseY = Gesture:getMouseLocation( Game.layers.active )
        for key, entity in pairs( Level:getEntitiesNearPos( { mouseX, mouseY }, { 20, 20 } ) ) do
          if entity.electrocute ~= nil then
            entity:electrocute()
          end
        end
      end
    end)
  end
end

function Gesture:click()
  -- calls if IsMouseDown
  clickEntity = Gesture:pickEntity(Gesture:getMouseLocation(Game.layers.active))
  if(clickEntity ~= nil) then
    --clickEntity:action()
    print "entity attacks"
  end
end

--Checks to see if the line dragged is from one entity to another
function Gesture:targetLine(a, b, c, d)
  -- does something if a line is swiped
  if Gesture:pickEntity(a, b) ~= nil and Gesture:pickEntity(c, d) ~= nil then
    local firstEntity = Gesture:pickEntity(a, b)
    local secondEntity = Gesture:pickEntity(c, d)
    print "success attack"
  else
    print "failure attack"
  end
end

function Gesture:trackSwipe()
  local x1, y1
  local x2, y2
  --============================
  --variables for movement type
  -- 1 is horizontal
  -- 2 is vertical
  -- 3 is diagonal down
  -- 4 is diagonal up
  --============================
  local swipe1, swipe2, swipe3, swipe4
  local swipeTimer = MOAITimer.new()
  swipeTimer:setSpan(1)
  swipeTimer:setMode(MOAITimer.LOOP)
  swipeTimer:setListener(MOAITimer.EVENT_TIMER_BEGIN_SPAN,
    function()
      --stores starting location of current loop
    x1, y1 = Gesture:getMouseLocation(Game.layers.active)
  end)
  swipeTimer:setListener(MOAITimer.EVENT_TIMER_END_SPAN,
    function()
    --stores end location of current loop
    x2, y2 = Gesture:getMouseLocation(Game.layers.active)
    
    --no click and no movement, means simple click
    if(Gesture:isClickDown() ~= true) and (swipe1 == nil) then
      swipeTimer:stop()
      Gesture:click()
      return false
    --no click, clear 'cache'
    elseif(Gesture:isClickDown() ~= true) then
      swipeTimer:stop()
      swipe1, swipe2, swipe3, swipe4 = nil
      print "trackSwipe cleared"
      return true
    end
    
    --if swipe4 has data, calculate movement
    --if not, move all stored data and store new movement
    if(swipe4 ~= nil) then
      --calculate made swipe movement
      print("4 movements made:" .. swipe1, swipe2, swipe3, swipe4)
      swipeTimer:stop()
    elseif(Gesture:mouseMoved(x1, y1, x2, y2)) then
      swipe4 = swipe3
      swipe3 = swipe2
      swipe2 = swipe1
      swipe1 = Gesture:determineSwipe(x1, y1, x2, y2)
      print "movement stored"
    end
  end)
swipeTimer:start()
end

--Determines the movement type the player swiped
function Gesture:determineSwipe(a, b, c ,d )
  local movementType = 5
  local x1, y1 = Game.layers.active:worldToWnd(a, b)
  local x2, y2 = Game.layers.active:worldToWnd(c, d)
  local deltaX = math.abs(x2 - x1)
  local deltaY = math.abs(y2 - y1)
  print ("X: " .. deltaX .. "Y:" .. deltaY)
  
  --picks between movement types
  if((math.abs(deltaX - deltaY)) < 48) then
    --Diagonal, choose between down and up
    if((y2 - y1) < 0) then
      movementType = 4
    else
      movementType = 3
    end
  elseif(deltaX < deltaY) then
    --Vertical
    movementType = 2
  else
    --Horizontal
    movementType = 1
  end
  
  return movementType
end

-- Picks the entity at coordinates x & y
function Gesture:pickEntity(x, y)
  local obj = Game.partitions.active.propForPoint( Game.partitions.active, Gesture:getMouseLocation(Game.layers.active))
  for key, entity in pairs(Level.entities) do
    if entity.prop == obj then
      return entity
    end
  end
  return nil
end

-- Compares a, b and c, d to see if the mouse moved. Ignorelength is to prevent over-sensitivity
function Gesture:mouseMoved(a, b, c, d)
  local ignoreLength = 48
  if((a - c) > ignoreLength) or ((b - d) > ignoreLength) or ((a - c) < -ignoreLength) or ((b - d) < -ignoreLength) then
    return true
  end
  return false
end

--If the input was held down
function Gesture:isClickDown()
  if MOAIInputMgr.device.mouseLeft ~= nil and MOAIInputMgr.device.mouseLeft:isDown() then
    return true
  end
  if MOAIInputMgr.device.touch ~= nil and MOAIInputMgr.device.touch:isDown () then
    return true
  end
  return false
end

--only handles mouse location for now.  if you pass in a layer, this will return
--in the layer's coordinate system
function Gesture:getMouseLocation(layer)
  if layer == nil then
    return MOAIInputMgr.device.pointer:getLoc ()
  else
    return layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc ())
  end
end