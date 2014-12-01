module ( "InputManager", package.seeall )

------------------------------------------------
-- initialize ( )
-- Setups the callback for updating pointer
-- position on both mouse and touches
------------------------------------------------
function InputManager:initialize ()

  if MOAIInputMgr.device.keyboard then
    function onKeyboardEvent ( key, down )
      --print( "key: " .. tostring( key ) .. "down: " .. tostring( down ) )
      if key == 49 and down == false then 
        print( "saving & destroying" )
        Level:saveLevel()
        Level:destroy()
      end
      
      if key == 50 and down == false then 
        Level:loadLevel()
      end
      
      if key == 51 and down == false then
        Level.Sorcerer:fireball(Gesture:getMouseLocation(Game.layers.active))
      end
      
      if key == 52 and down == false then
        for key, entity in pairs( Level.playerEntities.archers ) do
          entity:setAim(5)
        end
      end
      if key == 53 and down == false then
        for key, entity in pairs( Level.playerEntities.archers ) do
          entity:setAim(-5)
        end
      end
      if key == 54 and down == false then
        for key, entity in pairs( Level.playerEntities.archers ) do
          entity:setStrength(5)
        end
      end
      if key == 55 and down == false then
        for key, entity in pairs( Level.playerEntities.archers ) do
          entity:setStrength(-5)
        end
      end
    end
  
    MOAIInputMgr.device.keyboard:setCallback ( onKeyboardEvent )
  end
  
  if MOAIInputMgr.device.pointer then
    function onMouseEvent( )
      local mouseDown = MOAIInputMgr.device.mouseLeft:isDown()
      local mx, my = MOAIInputMgr.device.pointer:getLoc()
      --print( "mousedown: " .. tostring( mouseDown ) )
      --print( "mouseX: " .. tostring( mx ) )
      --print( "mouseY: " .. tostring( my ) )
      Game:onInput( mouseDown, mx, my )
    end
    
    MOAIInputMgr.device.mouseLeft:setCallback( onMouseEvent )
  end
  
  if MOAIInputMgr.device.touch then
    function onTouchEvent( eventType, idx, x, y, tapCount )
      local touchDown = false
      if eventType == MOAITouchSensor.TOUCH_DOWN or eventType == MOAITouchSensor.TOUCH_MOVE then touchDown = true end
      Game:onInput( touchDown, x, y )
    end
    
    MOAIInputMgr.device.touch:setCallback( onTouchEvent )
  end
end

function InputManager:isDown()
  if MOAIInputMgr.device.pointer then 
    return MOAIInputMgr.device.mouseLeft:isDown()
  elseif MOAIInputMgr.device.touch then 
    return MOAIInputMgr.device.touch:isDown()
  end
end

function InputManager:getPointerLoc()
  if MOAIInputMgr.device.pointer then
    return MOAIInputMgr.device.pointer:getLoc()
  elseif MOAIInputMgr.device.touch then
    local t1 = MOAIInputMgr.device.touch:getActiveTouches()
    return MOAIInputMgr.device.touch:getTouch( t1 )
  end
end