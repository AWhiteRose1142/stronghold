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
  self.layers.background = MOAILayer2D.new()
  
  self.partitions = {}
  self.partitions.buttons = MOAIPartition.new()
  self.layers.user:setPartition( self.partitions.buttons )
  
  for key, layer in pairs( self.layers ) do
    layer:setViewport( gameViewport )
  end
  
  local renderTable = {
    self.layers.background,
    self.layers.user,
  }
  
  MOAIRenderMgr.setRenderTable( renderTable )
  
end

function MainMenu:loadBackground()
  self.backgroundProps = {}
  local backgroundDeck = ResourceManager:get( 'mainMenuBackground' )
  
  -- Make the prop
  local backgroundProp = MOAIProp2D.new()
  backgroundProp:setDeck( backgroundDeck )
  backgroundProp:setScl( 2.5, 2.5 )
  self.layers.background:insertProp( backgroundProp )
  table.insert( self.backgroundProps, backgroundProp )
end

function MainMenu:loadButtons()
  self.buttons = {}
  
  local deck = ResourceManager:get( "buttonPH" )
  
  self.buttons.newGame = {}
  self.buttons.newGame.prop = MOAIProp2D.new()
  self.buttons.newGame.prop:setDeck( deck )
  self.buttons.newGame.prop:setLoc( 0, 70 )
  self.buttons.newGame.prop:setScl( 4, 4 )
  self.buttons.newGame.isClicked = false
  self.layers.user:insertProp( self.buttons.newGame.prop )
  self.partitions.buttons:insertProp( self.buttons.newGame.prop )
  
  -- Button behavior for when it gets clicked
  self.buttons.newGame.callback = function( down )
    if down then
      self.buttons.newGame.prop:setScl( 3.5, 3.5 )
      self.buttons.newGame.isClicked = true
    end
    if down ~= true and self.buttons.newGame.isClicked == true then
      self.buttons.newGame.prop:setScl( 4, 4 )
      self.buttons.newGame.isClicked = false
      Game:startNewState( "level" )
    end
  end
  
end

function MainMenu:onInput( down, x, y )
  local x, y = self.layers.user:wndToWorld(MOAIInputMgr.device.pointer:getLoc ())
  self:pickProp( x, y )
end

function MainMenu:pickProp( x, y )
  local obj = self.partitions.buttons.propForPoint( self.partitions.buttons, x, y )
  for key, button in pairs( self.buttons ) do
    if button.prop == obj then
      button.callback( MOAIInputMgr.device.mouseLeft:isDown() )
    end
  end
  return nil
end

function MainMenu:destroy()
  self.initialized = false
end