local class = require 'libs/middleclass'

Sorcerer = class('sorcerer')

function Sorcerer:initialize( parent, position, layer )
  local x, y = unpack( position )
  self.spriteSheet = MOAITileDeck2D.new()
  self.spriteSheet:setTexture('res/img/Wizard.png')
  self.spriteSheet:setSize( 4, 1 )
  self.spriteSheet:setRect( -8, -8, 8, 8 )
  
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.spriteSheet )
  self.prop:setLoc( ( x + 2 ), ( y + 12 ) )
  self.prop:setParent( parent )
  
  layer:insertProp( self.prop )
  return self.prop
end

function Sorcerer:clicked()
  self.curve = MOAIAnimCurve.new()
  curve:setKey(1, 0.5, 1 )
end