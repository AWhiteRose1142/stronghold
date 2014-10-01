local class = require 'libs/middleclass'

Wall = class('wall')
local WORLDHEIGHT_HEALTH_RATIO = 3.125

function Wall:initialize( height, position, layer, health )
  local x, y = unpack( position )
  self.height = height
  self.health = 32 + ( height * 50 )
  self.baseX, self.baseY = x, y
  self.type = "wall"
  self.layer = layer
  
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
  
  self:initializePhysics( position, height )
  if health ~= nil then
    self:damage( self.health - health )
  end
  
  -- Put the wall in the Level's stores
  table.insert( Level.entities, self )
  table.insert( Level.playerEntities.walls, self )
end

function Wall:update()
  if self.health <= 0 then
    x, y = self.physics.body:getPosition()
    self.physics.body:setTransform( x, y - ( 17 + ( self.height * 16 ) ) )
  end
end

function Wall:damage( damage )
  self.health = ( self.health - damage )
  self.transform:addLoc( 0, - ( damage / WORLDHEIGHT_HEALTH_RATIO ) )
  if self.health <= 0 then
    print( "this wall is destroyed" )
  end
end

function Wall:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Wall:getTransform()
  return self.transform
end

function Wall:getTopLoc()
  return self.topProp:getLoc()
end

function Wall:initializePhysics( position, height )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.KINEMATIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -8, -8, 8, 16 * height )
  -- Cat, mask, group
  self.physics.fixture:setFilter( 0x04, 0x02 )
  self.transform:setParent( self.physics.body )
  self.physics.fixture:setCollisionHandler( onCollide, MOAIBox2DArbiter.BEGIN )
end

function onCollide( phase, fixtureA, fixtureB, arbiter )
  print( "boop! says a wall" )
end

function Wall:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  print( "destroying a wall" )
  if self.timer then self.timer:stop() end
  
  self.layer:removeProp( self.baseProp )
  self.layer:removeProp( self.topProp )
  for key, prop in pairs(self.midProps) do
    self.layer:removeProp( prop )
  end
  
  self.physics.body:setTransform( 0, -1000 )
  Level:removeEntity( self )
end