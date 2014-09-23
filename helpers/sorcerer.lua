local class = require 'libs/middleclass'

Sorcerer = class('sorcerer')

function Sorcerer:initialize( parent, position, layer, partition )
  local x, y = unpack( position )
  self.spriteSheet = MOAITileDeck2D.new()
  self.spriteSheet:setTexture('res/img/Wizard.png')
  self.spriteSheet:setSize( 6, 1 )
  self.spriteSheet:setRect( -8, -8, 8, 8 )
  self.transform = parent
  
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.spriteSheet )
  self.prop:setLoc( ( x + 2 ), ( y + 12 ) )
  self.prop:setParent( parent )
  partition:insertProp(self.prop)
  
  -- load animation for attacking
  self.curve = MOAIAnimCurve.new()
  self.curve:reserveKeys(6)
  
  for i=1,6,1 do
    -- keynumber, tijd waarop het moet plaatsvinden, value van de key (om welk plaatje gaat het dus)
    self.curve:setKey(i, 0.12 * i, i)
  end
  
  self.anim = MOAIAnim:new()
  self.anim:reserveLinks(1)
  self.anim:setLink(1, self.curve, self.prop, MOAIProp2D.ATTR_INDEX)
  self.anim:setMode(MOAITimer.NORMAL)
  self.anim:setSpan(6 * 0.12)
  
  -- ability scores (for now)
  self.health = 15
  self.damage = 10
  
  return self.prop
end

function Sorcerer:getLoc()
  local x1, y1 = self.transform:getLoc()
  local x2, y2 = self.prop:getLoc()
  return (x1 + x2), (y1 + y2)
end

function Sorcerer:action()
  self.anim:start()
  print"sorcerer attacks"
end