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
      
      -- Numpad 6
      if key == 54 and down == false then 
        Fireball:new( { 0, 0 }, Level.layers.active, 10, { 5, -5 } )
      end
      
      -- Numpad 7
      if key == 55 and down == false then 
        Game:startNewState( "level" )
      end
      
      -- Numpad 8
      if key == 56 and down == false then 
        Game:startNewState( "mainmenu" )
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
end