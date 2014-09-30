local class = require 'libs/middleclass'

Archer = class('archer')

local animationDefinitions = {
  stand = {
    startFrame = 1,
    frameCount = 1,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
  attack = {
    startFrame = 2,
    frameCount = 4,
    time = 0.2,
    mode = MOAITimer.LOOP
  },
}

function Archer:initialize( parent, position, layer, partition )
  self.isBusy = false
  self.health = 10
  self.strength = 10
  self.type = "archer"
  self.timer = nil
  self.target = nil
  self.layer = layer
  self.transform = parent
  self.x, self.y = unpack(position)
  self.aim = 45
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'archer' )
  
  -- Make the prop
  self.prop = MOAIProp2D.new()
  self.prop:setLoc( self.x, self.y )
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
end

function Archer:update()
  self:attack()
  if self.health <= 0 then
    self:destroy()
  end
end

function Archer:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Archer:getTransform()
  return self.physics.body.transform
end

--===========================================
-- Actions
--===========================================

function Archer:attack( )
  if self.timer ~= nil then
    --DO NOTHING
  else
    self.timer = MOAITimer.new()
    self.timer:setMode( MOAITimer.LOOP )
    self.timer:setSpan( 2 )
    self.timer:setListener( 
      MOAITimer.EVENT_TIMER_END_SPAN,
      bind( self, "attack" )
    )
    self.timer:setListener( 
    MOAITimer.EVENT_TIMER_BEGIN_SPAN, 
    function() 
      table.insert(Level.entities, Arrow:new({self.x, self.y}, self.layer, self.aim, self.strength)) 
    end
    )
    self.timer:start()
    self:startAnimation( "attack" )
    --table.insert(Level.entities, Arrow:new({self.x, self.y}, self.layer, self.aim, self.strength))
  end
end

function Archer:damage( damage )
  self.health = self.health - damage
  if self.health <= 0 then
    print( "the archer is dead" )
  end
end

--Rotates the archer as much as the device location differs in Y value (height)
function Archer:aim()
  --something
end

--===========================================
-- Animation control
--===========================================

function Archer:getAnimation( name )
  return self.animations[name]
end

function Archer:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function Archer:startAnimation( name )
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation( name )
  self.currentAnimation:start()
  return self.currentAnimation
end

--===========================================
-- Event handlers
--===========================================

function Archer:onCollide( phase, fixtureA, fixtureB, arbiter )
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

function Archer:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  Level.score = Level.score - 10
  print( "destroying an archer" )
  if self.timer then self.timer:stop() end
  self.layer:removeProp( self.prop )
  --PhysicsHandler:sceduleForRemoval( self.physics.body )
  --self.physics.body:destroy()
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( 0, -1000 )
  Level:removeEntity( self )
end

function Archer:initializePhysics( position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.KINEMATIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -3, -8, 5, 8 )
  self.prop:setParent( self.physics.body )
  

  self.physics.fixture:setCollisionHandler( bind( self, 'onCollide'), MOAIBox2DArbiter.BEGIN )
  --self.physics.fixture:setCollisionHandler( bind( self, 'deathCheck'), MOAIBox2DArbiter.POST_SOLVE )
end

function Archer:addAnimation( name, startFrame, frameCount, time, mode )
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