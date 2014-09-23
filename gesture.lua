module( "Gesture", package.seeall )

function Gesture:click()
  -- calls if IsMouseDown
  clickEntity = Game:pickEntity(MOAIInputMgr.device.pointer:getLoc())
  clickEntity:action()
end

function Gesture:targetLine(a, b, c, d)
  -- does something if a line is swiped
  if Game:pickEntity(a, b) ~= nil and Game:pickEntity(c, d) ~= nil then
    local firstEntity = Game:pickEntity(a, b)
    local secondEntity = Game:pickEntity(c, d)s
    print "success attack"
  else
    print "failure attack"
  end
end

function Gesture:mouseMoved(a, b, c, d)
  if((a - c) > 48) or ((b - d) > 48) or ((a - c) < -48) or ((b - d) < -48) then
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

--Note these keyboard ones dont work with Akuma host

--If the key was pressed during the last update
function Gesture:isKeyPress(key)
  return MOAIInputMgr.device.keyboard:keyDown(key)
end

--If the key is held down
function Gesture:isKeyDown(key)
  return MOAIInputMgr.device.keyboard:keyIsDown(key)
end