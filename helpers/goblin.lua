local class = require 'libs/middleclass'

Goblin = class('goblin')

local animationDefinitions = {
  walk = {
    startFrame = 1,
    frameCount = 4,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
  attack = {
    startFrame = 5,
    frameCount = 3,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
  electrocute = {
    startFrame = 8,
    frameCount = 2,
    time = 0.1,
    mode = MOAITimer.LOOP
  },
}

function Goblin:initialize( position, layer, health )
  self.health = 6
  self.type = "goblin"
  self.timer = nil
  self.target = nil
  self.layer = layer
  self.range = 120
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'goblin' )
  
  -- Make the prop
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.deck )
  layer:insertProp( self.prop )
  
  -- Initialize animations
  self.remapper = MOAIDeckRemapper.new()
  self.remapper:reserve( 1 )
  self.prop:setRemapper( self.remapper )
  
  self.animations = {}
  for name, def in pairs( animationDefinitions ) do
    self:addAnimation( name, def.startFrame, def.frameCount, def.time, def.mode )
  end
  
  -- Setup physics
  self:initializePhysics( position )
  
  -- For loading a footman with certain amount of health.
  if health ~= nil then
    self:damage( self.health - health )
  end
    
  -- Code for testing
  --self:startAnimation( "electrocute" )
  self:move( -1 )
  table.insert( Level.entities, self )
  table.insert( Level.enemyEntities.footmen, self )
end

function Goblin:update()
  for key, entity in pairs( Level.playerEntities.archers ) do
    if self:inRange( entity ) then
      self.target = entity
      self:attack()
    end
  end
  
  for key, entity in pairs( Level.playerEntities.walls ) do
    if self:inRange( entity ) then
      self.target = entity
      self:attack()
    end
  end
  
  if self.target == nil then
    self:move( -1 )
  end
  
  if self.health <= 0 then
    self:destroy()
  end
end

function Goblin:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Goblin:getTransform()
  return self.physics.body.transform
end

function Goblin:inRange( entity )
  local ex, ey = unpack( entity:getPosition() )
  local gx, gy = unpack( self:getPosition() )
  local dx = math.abs(gx - ex)
  local dy = math.abs(gy - ey)
  if (dx + dy) <= self.range then
    return true
  end
  return false
end

--===========================================
-- Actions
--===========================================

function Goblin:move( direction )
  self.prop:setScl( -direction, 1 )
  velX, velY = self.physics.body:getLinearVelocity()
  self.physics.body:setLinearVelocity( direction * 10, velY )
  
  if ( self.currentAnimation ~= self:getAnimation ( 'walk' ) ) and not self.attacking then
    self:startAnimation ( 'walk' )
  end
end

function Goblin:stopMoving()
  self.physics.body:setLinearVelocity ( 0, 0 )
  self:stopCurrentAnimation()
end

function Goblin:attack( )
  if self.timer ~= nil then
    --DO NOTHING
  else
    self.timer = MOAITimer.new()
    self.timer:setMode( MOAITimer.LOOP )
    self.timer:setSpan( 0.6 )
    self.timer:setListener( 
      MOAITimer.EVENT_TIMER_END_SPAN,
      bind( self, "attack" )
    )
    self.timer:setListener(MOAITimer.EVENT_TIMER_BEGIN_SPAN,
    function()
        table.insert(Level.entities, Crossbolt:new( self:getPosition(), self.layer, 45, 10 ))
      end)
    self:stopMoving()
    self:startAnimation( "attack" )
    self.timer:start()
  end
end

function Goblin:damage( damage )
  self.health = self.health - damage
  if self.health <= 0 then
    print( "the goblin is dead" )
  end
end

function Goblin:electrocute()
  print( "electrocuting" )
  self:stopMoving()
  self:startAnimation("electrocute")
  if self.timer ~= nil then 
    self.timer:stop()
    self.timer = nil
  end
  self.timer = MOAITimer.new()
  self.timer:setMode( MOAITimer.NORMAL )
  self.timer:setSpan( 2 )
  self.timer:setListener( 
    MOAITimer.EVENT_TIMER_END_SPAN,
    bind( self, "destroy" )
  )
  self.timer:start()
end

--===========================================
-- Animation control
--===========================================

function Goblin:getAnimation( name )
  return self.animations[name]
end

function Goblin:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function Goblin:startAnimation( name )
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation( name )
  self.currentAnimation:start()
  return self.currentAnimation
end

--===========================================
-- Event handlers
--===========================================

function Goblin:onCollide( phase, fixtureA, fixtureB, arbiter )
  print( "boop!" )
  
  local entityB = Level:getEntityFromFixture( fixtureB )
  if entityB ~= nil then
    if entityB.type == "wall" then
      print( "into a wall" )
      self.target = entityB
      self:attack( )
    end
  end
end

--===========================================
-- Utility functions, consider these private
--===========================================

function Goblin:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  Level.score = Level.score + 10
  print( "destroying a goblin" )
  if self.timer then self.timer:stop() end
  self.layer:removeProp( self.prop )
  --PhysicsHandler:sceduleForRemoval( self.physics.body )
  --self.physics.body:destroy()
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( 0, -1000 )
  Level:removeEntity( self )
end

function Goblin:initializePhysics( position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.DYNAMIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -3, -8, 5, 8 )
  -- Cat, mask, group
  self.physics.fixture:setFilter( 0x02, 0x04 )
  self.prop:setParent( self.physics.body )

  self.physics.fixture:setCollisionHandler( bind( self, 'onCollide'), MOAIBox2DArbiter.BEGIN )
  --self.physics.fixture:setCollisionHandler( bind( self, 'deathCheck'), MOAIBox2DArbiter.POST_SOLVE )
end

function Goblin:addAnimation( name, startFrame, frameCount, time, mode )
  -- This curve is going to do shit, yo
  local curve = MOAIAnimCurve.new()
  -- Reserve start and end keys
  curve:reserveKeys( 2 )
  -- Params: starting key, time, value ( index of in tilesheet ), animcurve type
  curve:setKey( 1, 0, startFrame, MOAIEaseType.LINEAR )
  curve:setKey( 2, time * frameCount, startFrame + frameCount, MOAIEaseType.LINEAR )
  
  -- Making the animation
  local anim = MOAIAnim:new()
  -- Reserve a link to connect the curve with the remapper
  anim:reserveLinks( 1 )
  anim:setLink( 1, curve, self.remapper, 1 )
  anim:setMode( mode )
  self.animations[name] = anim
end