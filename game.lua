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
    
    if UpgradeMenu.initialized then
      UpgradeMenu:update()
    end
    
  end
end

function Game:initialize()
  print( GAMENAME .. " is initializing" )
  
  -- Load the resource definitions
  Index:loadDefinitions()
  InputManager:initialize()
  Player:initialize()
  SoundMachine:initialize()
  nextState = "mainmenu"
  tut = nil
end

function Game:startNewState( state, tutEx )
  
  if currentState == "level" then
    Level:destroy()
  end
  if currentState == "mainmenu" then
    MainMenu:destroy()
  end
  if currentState == "upgrademenu" then
    UpgradeMenu:destroy()
  end
  if currentState == "loadmenu" then
    LoadMenu:destroy()
  end
  if currentState == "tutprompt" then
    tut:destroy()
  end
  
  MOAIRenderMgr.clearRenderStack ()
	MOAISim.forceGarbageCollection ()
  
  if state == "level" then
    SoundMachine:stop( "main" )
    SoundMachine:play( "level" )
    Level:initialize()
  end
  if state == "mainmenu" then
    SoundMachine:stop( "level" )
    SoundMachine:play( "main" )
    MainMenu:initialize()
  end
  if state == "upgrademenu" then
    SoundMachine:stop( "level" )
    SoundMachine:play( "main" )
    UpgradeMenu:initialize()
  end
  if state == "loadmenu" then
    LoadMenu:initialize()
  end
  if state == "tutprompt" then
    tut = tutEx
  end
  
  currentState = state
  nextState = nil
end

function Game:onInput( down, x, y )
  --print( "Game onInput recieved: " .. tostring( down ) .. " " .. x .. " " .. y )
  if currentState == "level" and Level.initialized then
    Level:onInput( down, x, y )
  end
  if currentState == "mainmenu" and MainMenu.initialized then
    MainMenu:onInput( down, x, y )
  end
  if currentState == "upgrademenu" and UpgradeMenu.initialized then
    UpgradeMenu:onInput( down, x, y )
  end
  if currentState == "loadmenu" and LoadMenu.initialized then
    LoadMenu:onInput( down, x, y )
  end
  if currentState == "tutprompt" and tut.initialized then
    tut:onInput( down, x, y )
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
