local class = require 'libs/middleclass'

Wall = class('wall')
local WORLDHEIGHT_HEALTH_RATIO = 3.125

function Wall:initialize( height, position, layer )
  local x, y = unpack( position )
  self.health = 32 + ( height * 50 )
  self.baseX, self.baseY = x, y
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.baseDeck = ResourceManager:get( 'wallBase' )
  self.topDeck = ResourceManager:get( 'wallTop' )
  self.midDeck = ResourceManager:get( 'wallMiddle' )
  
  self.transform = MOAITransform2D.new()
  
  -- Move these props to the right offset
  self.baseProp = MOAIProp2D.new()
  self.baseProp:setDeck( self.baseDeck )
  layer:insertProp( self.baseProp )
  self.baseProp:setParent( self.transform )
  
  self.midProps = { }
  
  for i = 1, ( height - 1 ) do
    local midProp = MOAIProp2D.new()
    midProp:setDeck( self.midDeck )
    midProp:setLoc( 0, 16 * i )
    layer:insertProp( midProp )
    midProp:setParent( self.transform )
    table.insert( self.midProps, midProp )
  end
  
  self.topProp = MOAIProp2D.new()
  self.topProp:setDeck( self.topDeck )
  layer:insertProp( self.topProp )
  self.topProp:setLoc( 0, 16 * height )
  self.topProp:setParent( self.transform )
  
  self.transform:setLoc( x, y )
end

function Wall:damage( damage )
  self.health = self.health - damage
  self.transform:addLoc( 0, - ( damage / WORLDHEIGHT_HEALTH_RATIO ) )
  if self.health <= 0 then
    print( "this wall is destroyed" )
  end
end

function Wall:getTransform()
  return self.transform
end

function Wall:getTopLoc()
  return self.topProp:getLoc()
end