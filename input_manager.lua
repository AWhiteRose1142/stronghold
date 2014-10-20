module ( "InputManager", package.seeall )

------------------------------------------------
-- initialize ( )
-- Setups the callback for updating pointer
-- position on both mouse and touches
------------------------------------------------
function InputManager:initialize ()

  if MOAIInputMgr.device.keyboard then
    function onKeyboardEvent ( key, down )
      print( "key: " .. tostring( key ) .. "down: " .. tostring( down ) )
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
    function onMouseEvent( x, y )
      Game:onInput( MOAIInputMgr.device.mouseLeft:isDown(), x, y )
    end
    
    MOAIInputMgr.device.mouseLeft:setCallback( onMouseEvent )
  end
  
  if MOAIInputMgr.device.touch then
    function onTouchEvent( eventType, idx, x, y, tapCount )
      local down = false
      if eventType == MOAITouchSensor.TOUCH_DOWN then down = true end
      Game:onInput( down, x, y )
    end
    
    MOAIInputMgr.device.touch:setCallback( onTouchEvent )
  end
end