module( "Game", package.seeall )

require "index"

local currentState = nil
local nextState = nil

-- Start function, is called from main, also contains the gameloop
function Game:start()
  -- Do the initial setup
  
  self:initialize()
  
  while ( true ) do
    coroutine.yield() -- Andere threads laten draaien
    
    if nextState ~= nil then
      Game:startNewState( nextState )
    end
    
    if Level.initialized then
      Level:update()
    end
    
  end
end

function Game:initialize()
  print( GAMENAME .. " is initializing" )
  
  -- Load the resource definitions
  Index:loadDefinitions()
  InputManager:initialize()
  Player:initialize()
  nextState = "level"
  
end

function Game:startNewState( state )
  
  if currentState == "level" then
    Level:destroy()
  end
  if currentState == "mainmenu" then
    MainMenu:destroy()
  end
  if currentState == "upgrade" then
    Upgrade:destroy()
  end
  
  MOAIRenderMgr.clearRenderStack ()
	MOAISim.forceGarbageCollection ()
  
  if state == "level" then
    Level:initialize()
  end
  if state == "mainmenu" then
    MainMenu:initialize()
  end
  if state == "upgrade" then
    Upgrade:initialize()
  end
  
  currentState = state
  nextState = nil
end

function Game:onInput( down, x, y )
  if currentState == "level" and Level.initialized then
    Level:onInput( down, x, y )
  end
  if currentState == "mainmenu" and MainMenu.initialized then
    MainMenu:onInput( down, x, y )
  end
  if currentState == "upgrade" and Upgrade.initialized then
    Upgrade:onInput( down, x, y )
  end
end

--===============================================
-- Utility functions
--===============================================

function sleepCoroutine ( time )
  local timer = MOAITimer.new ()
  timer:setSpan ( time )
  timer:start ()
  MOAICoroutine.blockOnAction ( timer )
end
