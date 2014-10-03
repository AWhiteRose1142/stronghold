-- Name of the game
GAMENAME = "stronghold"
SAVE_FILE_NAME = "save"

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

function normalize( x, y )
  local length = math.sqrt( (x*x) + (y*y) )
  local xR = x / length
  local yR = y / length
  return { xR, yR }
end

function distance( startP, endP )
  sPX, sPY = unpack( startP )
  ePX, ePY = unpack( endP )
  local x = ePX - sPX
  local y = ePY - sPY
  return math.sqrt( (x*x) + (y*y) )
end

function getRotationFrom( x, y )
  local nX, nY = unpack( normalize( x, y ) )
  return math.deg( math.atan2( nY, nX ) )
end