local class = require 'libs/middleclass'

Orc = class('orc')

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

function Orc:initialize( position, layer, health )
  self.health = 11
  self.strength = 5
  self.type = "orc"
  self.timer = nil
  self.target = nil
  self.layer = layer
  self.walkSpeed = 17
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'orc' )
  
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
  
  -- For loading a Orc with certain amount of health.
  if health ~= nil then
    self:damage( self.health - health )
  end
    
  -- Code for testing
  --self:startAnimation( "electrocute" )
  self:move( -1 )
  table.insert( Level.entities, self )
  table.insert( Level.enemyEntities.orcs, self )
end

function Orc:update()
  if self.health <= 0 then
    self:destroy()
  end
end

function Orc:slow()
  self.walkSpeed = 5
  if self.taget == nil and self.health > 0 then self:move( -1 ) end
  local timer = MOAITimer.new()
  timer:setMode( MOAITimer.NORMAL )
  timer:setSpan( 5 )
  timer:setListener( 
    MOAITimer.EVENT_TIMER_END_SPAN,
    bind( self, "restoreSpeed" )
  )
  timer:start()
end

function Orc:restoreSpeed()
  self.walkSpeed = 17
  if self.taget == nil and self.health > 0 then self:move( -1 ) end
end

function Orc:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Orc:getTransform()
  return self.physics.body.transform
end

--===========================================
-- Actions
--===========================================

function Orc:move( direction )
  self.prop:setScl( -direction, 1 )
  velX, velY = self.physics.body:getLinearVelocity()
  self.physics.body:setLinearVelocity( direction * self.walkSpeed, velY )
  
  if ( self.currentAnimation ~= self:getAnimation ( 'walk' ) ) and not self.attacking then
    self:startAnimation ( 'walk' )
  end
end

function Orc:stopMoving()
  self.physics.body:setLinearVelocity ( 0, 0 )
  self:stopCurrentAnimation()
end

function Orc:attack( )
  if self.target.health >= 0 then
    if self.timer ~= nil then
      SoundMachine:play( "crumble" )
      self.target:damage( self.strength )
    else
      self.timer = MOAITimer.new()
      self.timer:setMode( MOAITimer.LOOP )
      self.timer:setSpan( 0.6 )
      self.timer:setListener( 
        MOAITimer.EVENT_TIMER_END_SPAN,
        bind( self, "attack" )
      )
      self.timer:start()
      self:stopMoving()
      self.target:damage( self.strength )
      self:startAnimation( "attack" )
    end
  else
    self:move( -1 )
    self.timer:stop()
    self.timer = nil
    self.target = nil
  end
end

function Orc:damage( damage )
  self.health = self.health - damage
  if self.health <= 0 then
    print( "the orc is dead" )
  end
end

function Orc:electrocute()
  print( "electrocuting" )
  SoundMachine:play( "zap" )
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

function Orc:getAnimation( name )
  return self.animations[name]
end

function Orc:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function Orc:startAnimation( name )
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation( name )
  self.currentAnimation:start()
  return self.currentAnimation
end

--===========================================
-- Event handlers
--===========================================

function Orc:onCollide( phase, fixtureA, fixtureB, arbiter )
  local entityB = Level:getEntityFromFixture( fixtureB )
  if entityB ~= nil then
    if entityB.type == "wall" or entityB.type == "tower" then
      print( "into a wall" )
      self.target = entityB
      self:attack( )
    end
  end
end

--===========================================
-- Utility functions, consider these private
--===========================================

function Orc:destroy()
  SoundMachine:play( "dying" )
  FloatyText:new( '+10', self.layer, self:getPosition() )
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  if Player.progress.mana > 95 then
    Player.progress.mana = 100
    HUD.manacost:setString("max")
  else
    Player.progress.mana = Player.progress.mana + 5
    HUD.manacost:setString("+5")
  end
  Player.progress.score = Player.progress.score + 10
  print( "destroying an orc" )
  if self.timer then self.timer:stop() end
  self.layer:removeProp( self.prop )
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( -100, -1000 )
  Level:removeEntity( self )
  
end

function Orc:initializePhysics( position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.DYNAMIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -6, -16, 10, 16 )
  -- Cat, mask, group
  self.physics.fixture:setFilter( 0x02, 0x04 )
  self.prop:setParent( self.physics.body )

  self.physics.fixture:setCollisionHandler( bind( self, 'onCollide'), MOAIBox2DArbiter.BEGIN )
  --self.physics.fixture:setCollisionHandler( bind( self, 'deathCheck'), MOAIBox2DArbiter.POST_SOLVE )
end

function Orc:addAnimation( name, startFrame, frameCount, time, mode )
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