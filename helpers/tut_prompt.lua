local class = require "libs/middleclass"

TutPrompt = class( "tutPrompt" )

function TutPrompt:initialize( userLayer, ignoreLayer, bgLayer, partition, tutType, callback )
  self.userLayer = userLayer
  self.ignoreLayer = ignoreLayer
  self.bgLayer = bgLayer
  self.partition = partition
  self.type = tutType
  self.callback = callback
  
  self.tutDeck = ResourceManager:get( self.type )
  self.tutProp = MOAIProp2D.new()
  self.tutProp:setDeck( self.tutDeck )
  self.bgLayer:insertProp( self.tutProp )
  
  self.button = Button:new( { 130, -80 }, self.userLayer, self.partition, self.ignoreLayer, "GOT IT!", 20 )
  self.button:setHandler( bind( self, "doCallback" ) )
end

function TutPrompt:doCallback()
  if self.callback ~= nil then 
    self:destroy()
    self.callback()
  end
end

function TutPrompt:destroy()
  self.ignoreLayer:removeProp( self.tutProp )
  self.button:destroy()
end