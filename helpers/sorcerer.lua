local class = require 'libs/middleclass'
require 'helpers/bolt'

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

function Sorcerer:clicked( layer )
  self.curve = MOAIAnimCurve.new()
  self.curve:reserveKeys(4)
  
  for i=1,4,1 do
    -- keynumber, tijd waarop het moet plaatsvinden, value van de key (om welk plaatje gaat het dus)
    self.curve:setKey(i, 0.075 * i, i)
  end
  
  self.anim = MOAIAnim:new()
  self.anim:reserveLinks(1)
  self.anim:setLink(1, self.curve, self.prop, MOAIProp2D.ATTR_INDEX)
  self.anim:setMode(MOAITimer.LOOP)
  self.anim:setSpan(4 * 0.075)
  self.anim:start()
  
  self.bolt = Bolt.new( {prop:getLoc()}, layer )
end