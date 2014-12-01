module( "LoadMenu", package.seeall )

loadIncrement = 10
loaders = 5

function LoadMenu:initialize()
  self:setupLayers()
  self:loadBackground()
  self:setupText()
  self:loadButtons()
  self.initialized = true
end

function LoadMenu:setupLayers()
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

function LoadMenu:loadBackground()
  self.backgroundProps = {}
  local backgroundDeck = ResourceManager:get( 'upgradeBackground' )
  
  -- Make the prop
  local backgroundProp = MOAIProp2D.new()
  backgroundProp:setDeck( backgroundDeck )
  backgroundProp:setScl( 2.9, 2.9 )
  self.layers.background:insertProp( backgroundProp )
  table.insert( self.backgroundProps, backgroundProp )
end

function LoadMenu:loadButtons()
  self.buttons = {}
  
  self.buttons[1] = {}
  self.buttons[1].button = Button:new( 
    { 0, 90 }, 
    self.layers.user, 
    self.partitions.user, 
    self.layers.ignoreLayer, 
    "WAVE 1",
    20
  )
  self.buttons[1].isClicked = false
  -- Button behavior for when it gets clicked
  self.buttons[1].button:setHandler( function()
    Game:startNewState( "level" )
  end )
  
  for i = 1, loaders do
    local waveCount = loadIncrement * i
    if Player.progress.unlockedWave < waveCount then return end
    self.buttons[i+1] = {}
    self.buttons[i+1].button = Button:new( 
      { 0, 90 + ( -60 ) * i }, 
      self.layers.user, 
      self.partitions.user, 
      self.layers.ignoreLayer, 
      "WAVE " .. waveCount,
      20
    )
    self.buttons[i+1].isClicked = false
    -- Button behavior for when it gets clicked
    self.buttons[i+1].button:setHandler( function()
      Player.progress = Player.saved[i]
      Game:startNewState( "level" )
    end )
  end
  
  --[[self.buttons.loadGame = {}
  self.buttons.loadGame.button = Button:new( { 100, -100 }, self.layers.user, self.partitions.user, self.layers.ignoreLayer, "LOAD GAME", 20 )
  self.buttons.loadGame.isClicked = false
  -- Button behavior for when it gets clicked
  self.buttons.loadGame.button:setHandler( function() Game:startNewState("loadmenu") end )
  ]]--
end

function LoadMenu:setupText()
  self.font = ResourceManager:get( "font" )
  local tx, ty = 0, 150
  self.title = self:makeTextBox( 40, { tx - 80, ty - 32, tx + 80, ty + 32 } )
  self.title:setString( "LOAD WAVE" )
end

function LoadMenu:onInput( down, x, y )
  local wx, wy = self.layers.user:wndToWorld( x, y )
  self:pickProp( down, wx, wy )
end

function LoadMenu:pickProp( down, x, y )
  local obj = self.partitions.user.propForPoint( self.partitions.user, x, y )
  for key, item in pairs( self.buttons ) do
    if item.button.prop == obj then
      item.button:onInput( down, true )
    end
  end
  return nil
end

function LoadMenu:showTut()
  self.buttons.newGame.button:destroy()
  self.fireBallTut = TutPrompt:new(
    'tutFireball', 
    function( )
      Game:startNewState( "level" )
    end
  )
end

function LoadMenu:makeTextBox( size, rectangle )
  local textBox = MOAITextBox.new()
  textBox:setFont( self.font )
  textBox:setTextSize( size )
  textBox:setRect( unpack( rectangle ) )
  textBox:setYFlip( true )
  textBox:setAlignment( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
  textBox:setColor( 100, 100, 100, 1 )
  textBox:setString( "test" )
  self.layers.ignoreLayer:insertProp( textBox )
  return textBox
end

function LoadMenu:destroy()
  self.initialized = false
end