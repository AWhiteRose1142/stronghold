-- Name of the game
GAMENAME = "stronghold"

-- World resolution
WORLDRES_X = 480
WORLDRES_Y = 320

-- Screen resolution
SCREENRES_X = 2 * WORLDRES_X
SCREENRES_Y = 2 * WORLDRES_Y

-- Clear color of the screen, now set to white
MOAIGfxDevice.getFrameBuffer ():setClearColor ( 1, 1, 1, 1 )

-- Utility function, maybe put this somewhere else
function bind(t, k)
  return function(...) return t[k](t, ...) end
end