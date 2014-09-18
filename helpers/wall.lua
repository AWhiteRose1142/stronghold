local class = require 'libs/middleclass'

Wall = class('wall')
local WORLDHEIGHT_HEALTH_RATIO = 1

function Wall:initialize( height, position )
  local x, y = unpack( position )
  self.health = height * 50
  self.baseX, self.baseY = x, y
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.baseDeck = ResourceManager:get( 'wall_base' )
  self.topDeck = ResourceManager:get( 'wall_top' )
  self.midDeck = ResourceManager:get( 'wall_middle' )
  
  self.prop = MOAITransform2D.new()
  
  -- Move these props to the right offset
  self.baseProp = MOAIGfxQuad2D.new()
  self.baseProp:setDeck( self.baseDeck )
  self.baseProp:setParent( self.tower )
  
  self.midProps = { }
  
  for i = 1, i < height, i + 1 do
    local midProp = MOAIGfxQuad2D.new()
    midProp:setDeck( self.midDeck )
    midProp:setParent( self.prop )
    midProp:setLoc( 0, 16 * ( height - 1 ) )
    table.insert( self.midProps, midProp )
  end
  
  self.topProp = MOAIGfxQuad2D.new()
  self.topProp:setDeck( self.topDeck )
  self.topProp:setParent( self.tower )
  self.topProp:setLoc( 0, 16 * height )
  
  self.prop:setLoc( x, y )
end

function Wall:damage( damage )
  self.health = self.health - damage
  self.prop:addLoc( 0, - ( damage / WORLDHEIGHT_HEALTH_RATIO ) )
  if self.health <= 0 then
    print( "this wall is destroyed" )
  end
end