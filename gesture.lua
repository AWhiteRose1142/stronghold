module( "Gesture", package.seeall )

function Gesture:click()
  -- calls if IsMouseDown
  clickEntity = Gesture:pickEntity(Gesture:getMouseLocation(Game.layers.active))
  if(clickEntity ~= nil) then
    clickEntity:action()
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

--Should store the X biggest movements somewhere
--Other function should check those X to determine the swiped pattern
--Disadvantage: swipe movements will always be X amount of movements
--Still possible: squares, circles (well, diamonds), lightning, wave, heartbeat

--Delta doesnt work yet! (problem with window or world coordinates
function Gesture:storeSwipe(a, b)
  local x1, y1 = a, b
  local x2, y2 = Gesture:getMouseLocation(Game.layers.active)
  local deltaX = x2 - x1
  local deltaY = y2 - y1
  print ("From " .. x1, y1 .. "to " .. x2, y2)
  print ("H: " .. deltaX .. "V: " .. deltaY)
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