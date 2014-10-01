local class = require 'libs/middleclass'

Button = class('button')

--Creates and places button with text
function Button:initialize( placement, layer, count )
  self.textsize = 20
  self.id = count
  
  --Ik zou een triple art maken per button, locked, unlocked, purchased
  
  self.deck = ResourceManager:get( 'button' )
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.deck )
  --coordinaten komen als world binnen, moet converted
  self.prop:setLoc( layer:wndToWorld( unpack(placement) ) )
  layer:insertProp( self.prop )
end

--Used to change text on button
function Button:changeText()
  --
end