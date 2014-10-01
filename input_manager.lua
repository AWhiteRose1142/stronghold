module ( "InputManager", package.seeall )

------------------------------------------------
-- initialize ( )
-- Setups the callback for updating pointer
-- position on both mouse and touches
------------------------------------------------
function InputManager:initialize ()
  
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
    if key == 100 then 
      
    end
  end

  MOAIInputMgr.device.keyboard:setCallback ( onKeyboardEvent )
end