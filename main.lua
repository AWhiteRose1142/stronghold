

--Variables
gameName = "Stronghold"
gameWidth = 480
gameHeight = 320
textureTotalAmount = 3
MOAISim.openWindow(gameName, gameWidth, gameHeight)

--Viewport for the game
gameViewport = MOAIViewport.new()
gameViewport:setSize(gameWidth, gameHeight)
gameViewport:setScale(gameWidth, gameHeight)

--Background layer, meant for wallpaper and information boxes
backgroundLayer = MOAILayer2D.new()
backgroundLayer:setViewport(gameViewport)
MOAIRenderMgr.pushRenderPass(backgroundLayer)

--Active layer, meant for walls, player and enemy sprites
activeLayer = MOAILayer2D.new()
activeLayer:setViewport(gameViewport)
MOAIRenderMgr.pushRenderPass(activeLayer)

--User (interface) layer, meant for player control
userLayer = MOAILayer2D.new()
userLayer:setViewport(gameViewport)
MOAIRenderMgr.pushRenderPass(userLayer)

MOAIGfxDevice.getFrameBuffer():setClearColor(0,0,0,1)

function setBackground()
  activeBackground = MOAIGfxQuad2D.new()
  activeBackground:setTexture(MOAITexture:load(''))
  
end

function textureLoad()
  for i=1, i == textureTotalAmount, 1 do
    print "Loading: " + (i/textureTotalAmount)
  end
end