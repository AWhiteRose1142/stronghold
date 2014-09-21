local class = require 'libs/middleclass'

Bolt = class('bolt')

function Bolt:initialize( position, layer )
  local x, y = unpack( position )
  self.spriteSheet = MOAITileDeck2D.new()
  self.spriteSheet:setTexture('res/img/WizardLightningAnimation.png')
  self.spriteSheet:setSize( 2, 1 )
  self.spriteSheet:setRect( -8, -8, 8, 8 )
  
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.spriteSheet )
  self.prop:setLoc( x, y )
  
  self.remapper = MOAIDeckRemapper.new()
  self.remapper:reserve(1)
  self.prop:setRemapper(self.remapper)

  self.curve = MOAIAnimCurve.new()
  self.curve:reserveKeys(2)

  curve:setKey( 1, 0, 1, MOAIEaseType.LINEAR)
  curve:setKey( 2, 0.1, 2, MOAIEaseType.LINEAR)

  self.anim = MOAIAnim.new()
  self.anim:reserveLinks(1)
  self.anim:setLink(1, self.curve, self.remapper, 1)
  self.anim:setMode(MOAITimer.LOOP)
  self.anim:start()
  
  layer:insertProp( self.prop )
  return self.prop
end

function Bolt:collide( x, y )
  -- checks to see if the bolt collides with an object
end