local class = require 'libs/middleclass'

Sorcerer = class('sorcerer')

local animationDefinitions = {
  cast = {
    startFrame = 1,
    frameCount = 6,
    time = 0.1,
    mode = MOAITimer.NORMAL
  },
}

function Sorcerer:initialize( parent, position, layer, partition )
  local x, y = unpack( position )
  self.type = "sorcerer"
  self.layer = layer
  self.partition = partition
  
  self.deck = ResourceManager:get( 'sorcerer' )
  self.transform = parent
  
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.deck )
  self.prop:setLoc( ( x + 2 ), ( y + 12 ) )
  self.prop:setParent( parent )
  self.partition:insertProp( self.prop )
  
  -- Initialize animations
  self.remapper = MOAIDeckRemapper.new()
  self.remapper:reserve( 1 )
  self.prop:setRemapper( self.remapper )
  
  self.animations = {}
  for name, def in pairs( animationDefinitions ) do
    self:addAnimation( name, def.startFrame, def.frameCount, def.time, def.mode )
  end
  
  -- ability scores (for now)
  self.health = 15
  self.damage = 10
  
  --layer:insertProp( self.prop )
  self:initializePhysics()
  
  table.insert( Level.entities, self )
  table.insert( Level.playerEntities.sorcerer, self )
end

function Sorcerer:update()
  -- Kan netter
  if Gesture.gestureTable ~= nil then
    self:cast()
  end
end

function Sorcerer:getPosition()
  local x1, y1 = self.transform:getLoc()
  local x2, y2 = self.prop:getLoc()
  return { (x1 + x2), (y1 + y2) }
end

function Sorcerer:getTransform()
  return self.transform
end

function Sorcerer:getLoc()
  local x1, y1 = self.transform:getLoc()
  local x2, y2 = self.prop:getLoc()
  return (x1 + x2), (y1 + y2)
end

function Sorcerer:cast()
  self:startAnimation( "cast" )
  return true
end

function Sorcerer:fireball( target )
  local position = self:getPosition()
  local fireball = Fireball:new( position, Game.layers.active, self.damage, target)
end

function Sorcerer:initializePhysics()
  self.physics = {}
  self.physics.fixture = nil
end

--================================================
-- Utility functions
--================================================

function Sorcerer:destroy()
  self.partition:removeProp( self.prop )
  Level:removeEntity( self )
end

--===========================================
-- Animation control
--===========================================

function Sorcerer:getAnimation( name )
  return self.animations[name]
end

function Sorcerer:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function Sorcerer:startAnimation( name )
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation( name )
  self.currentAnimation:start()
  return self.currentAnimation
end

function Sorcerer:addAnimation( name, startFrame, frameCount, time, mode )
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