local class = require 'libs/middleclass'

Archer = class('archer')

--To fire arrow, use this code
--table.insert(Level.entities, Arrow:new( self:getPosition(), self.layer, self.aim, self.strength)) 


local animationDefinitions = {
  stand = {
    startFrame = 1,
    frameCount = 1,
    time = 0.2,
    mode = MOAITimer.NORMAL
  },
  attack = {
    startFrame = 2,
    frameCount = 4,
    time = 0.6667,
    mode = MOAITimer.LOOP
  },
}

function Archer:initialize( position, layer, partition )
  self.isBusy = false
  self.health = 10
  self.strength = 10
  self.type = "archer"
  self.timer = nil
  self.target = nil
  self.layer = layer
  self.aim = 45
  self.wallOffset = { 0, -6 }
  self.mount = nil
  
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'archer' )
  
  -- Make the prop
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.deck )
  self.prop:setRot( (self.aim / 2) )
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
  
  table.insert( Level.entities, self )
  table.insert( Level.playerEntities.archers, self )
  self:startAttack()
  print("archer created")
end

function Archer:update()
  self.prop:setRot( (self. aim / 5) )
  if self.health <= 0 then
    print( "archer health low, destroying" )
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

function Archer:startAttack( )
  self.timer = MOAITimer.new()
  self.timer:setMode( MOAITimer.LOOP )
  self.timer:setSpan( 2 )
  self.timer:setListener( MOAITimer.EVENT_TIMER_END_SPAN, bind( self, "shootArrow" ) )
  self:startAnimation( "attack" )
  self.timer:start()
end

function Archer:shootArrow( )
  if Level.initialized == false then return end
  print("archer fires arrow")
  table.insert( Level.entities, Arrow:new( 
      self:getPosition(), 
      self.layer, 
      self.aim,
      self.strength
    )
  )
end

function Archer:damage( damage )
  self.health = self.health - damage
  if self.health <= 0 then
    Player.progress.score = Player.progress.score - 10
    Player.progress.archers = Player.progress.archers - 1
  end
end

--Rotates the archer as much as the device location differs in Y value (height)
function Archer:setAim( aim )
  self.aim = self.aim + aim
end

function Archer:setStrength( strength )
  self.strength = self.strength + strength
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
-- Utility functions, consider these private
--===========================================

function Archer:destroy()
  -- Ergens nog een sterfanimatie voor elkaar krijgen.
  
  self.mount.mountedEntity = nil
  print( "destroying an archer" )
  self.timer:stop()
  self.layer:removeProp( self.prop )
  
  -- Voor nu flikkeren we de physicsbody maar in het diepe, zijn we er vanaf.
  self.physics.body:setTransform( -1000, -1000 )
  Level:removeEntity( self )
end

function Archer:initializePhysics( position )
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody( MOAIBox2DBody.KINEMATIC )
  self.physics.body:setTransform( unpack( position ) )
  self.physics.fixture = self.physics.body:addRect( -6, -16, 10, 16 )
  self.prop:setParent( self.physics.body )
  self.physics.fixture:setFilter( 0x04, 0x02 )
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