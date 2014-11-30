local class = require "libs/middleclass"

TutPrompt = class( "tutPrompt" )

function TutPrompt:initialize( tutType, callback )
  Game:startNewState( "tutprompt", self )
  self.type = tutType
  self.callback = callback
  self:setupLayers()
  
  self.tutDeck = ResourceManager:get( self.type )
  self.tutProp = MOAIProp2D.new()
  self.tutProp:setDeck( self.tutDeck )
  self.layers.background:insertProp( self.tutProp )
  
  self.button = Button:new( { 255, -140 }, self.layers.user, self.partitions.user, self.layers.ignoreLayer, "GOT IT!", 20 )
  self.button:setHandler( bind( self, "doCallback" ) )
  self.initialized = true
end

function TutPrompt:doCallback()
  if self.callback ~= nil then 
    self.callback()
  end
end

function TutPrompt: setupLayers()
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

function TutPrompt:onInput( down, x, y )
  local wx, wy = self.layers.user:wndToWorld( x, y )
  self:pickProp( down, wx, wy )
end

function TutPrompt:pickProp( down, x, y )
  local obj = self.partitions.user.propForPoint( self.partitions.user, x, y )
  if self.button.prop == obj then
    self.button:onInput( down, true )
  end
  return nil
end

function TutPrompt:destroy()
  self.layers.ignoreLayer:removeProp( self.tutProp )
  self.button:destroy()
end