module( "MainMenu", package.seeall )

function MainMenu:initialize()
  self:setupLayers()
  self:loadBackground()
  self:loadButtons()
  self.initialized = true
end

function MainMenu:setupLayers()
  self.layers = {}
  self.layers.user = MOAILayer2D.new()
  self.layers.ignoreLayer = MOAILayer2D.new()
  self.layers.background = MOAILayer2D.new()
  
  self.partitions = {}
  self.partitions.user = MOAIPartition.new()
  self.layers.user:setPartition( self.partitions.user )
  
  for key, layer in pairs( self.layers ) do
    layer:setViewport( gameViewport )
  end
  
  local renderTable = {
    self.layers.background,
    self.layers.user,
    self.layers.ignoreLayer,
  }
  
  MOAIRenderMgr.setRenderTable( renderTable )
  
end

function MainMenu:loadBackground()
  self.backgroundProps = {}
  --local backgroundDeck = ResourceManager:get( 'upgradeBackground' )
  local logoDeck = ResourceManager:get( 'logo' )
  
  -- Make the prop
  --[[local backgroundProp = MOAIProp2D.new()
  backgroundProp:setDeck( backgroundDeck )
  backgroundProp:setScl( 2.9, 2.9 )
  self.layers.background:insertProp( backgroundProp )
  table.insert( self.backgroundProps, backgroundProp )
  ]]--
  
  local logoProp = MOAIProp2D.new()
  logoProp:setDeck( logoDeck )
  logoProp:setScl( 3, 3 )
  logoProp:setLoc( 0, 50 )
  self.layers.background:insertProp( logoProp )
  table.insert( self.backgroundProps, logoProp )
end

function MainMenu:loadButtons()
  self.buttons = {}
  
  self.buttons.newGame = {}
  self.buttons.newGame.button = Button:new( { -100, -100 }, self.layers.user, self.partitions.user, self.layers.ignoreLayer, "NEW GAME", 20 )
  self.buttons.newGame.isClicked = false
  -- Button behavior for when it gets clicked
  self.buttons.newGame.button:setHandler( bind( self, "showTut" ) )
  
  self.buttons.loadGame = {}
  self.buttons.loadGame.button = Button:new( { 100, -100 }, self.layers.user, self.partitions.user, self.layers.ignoreLayer, "LOAD GAME", 20 )
  self.buttons.loadGame.isClicked = false
  -- Button behavior for when it gets clicked
  self.buttons.loadGame.button:setHandler( function() Game:startNewState("loadmenu") end )
  
end

function MainMenu:onInput( down, x, y )
  local wx, wy = self.layers.user:wndToWorld( x, y )
  self:pickProp( down, wx, wy )
end

function MainMenu:pickProp( down, x, y )
  local obj = self.partitions.user.propForPoint( self.partitions.user, x, y )
  for key, item in pairs( self.buttons ) do
    if item.button.prop == obj then
      item.button:onInput( down, true )
    end
  end
  return nil
end

function MainMenu:showTut()
  self.buttons.newGame.button:destroy()
  self.fireBallTut = TutPrompt:new(
    'tutFireball', 
    function( )
      Game:startNewState( "level" )
    end
  )
end

function MainMenu:destroy()
  self.initialized = false
end