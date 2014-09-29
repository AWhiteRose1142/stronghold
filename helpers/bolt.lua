local class = require 'libs/middleclass'

Bolt = class('bolt')

local animationDefinitions = {
  fizzle = {
    startFrame = 1,
    frameCount = 2,
    time = 0.1,
    mode = MOAITimer.LOOP
  },
}

function Bolt:initialize( position, layer )
  local x, y = unpack( position )
  self.layer = layer
  -- Height 1 = top - bottom, 2 = top, mid, bottom - 3 = top, mid, mid, bottom
  self.deck = ResourceManager:get( 'bolt' )
  
  -- Make the prop
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.deck )
  layer:insertProp( self.prop )
  
  self.transform = MOAITransform2D.new()
  self.prop:setParent( self.transform )
  self.transform:setLoc( x, y )
  
  -- Initialize animations
  self.remapper = MOAIDeckRemapper.new()
  self.remapper:reserve( 1 )
  self.prop:setRemapper( self.remapper )
  
  self.animations = {}
  for name, def in pairs( animationDefinitions ) do
    self:addAnimation( name, def.startFrame, def.frameCount, def.time, def.mode )
  end
  
  self:startAnimation( 'fizzle' )
  
  timer = MOAITimer.new()
  timer:setMode( MOAITimer.NORMAL )
  timer:setSpan( 1 )
  timer:setListener( 
    MOAITimer.EVENT_TIMER_END_SPAN, 
    bind( self, "destroy" )
  )
  timer:start()
end

function Bolt:getPosition()
  local thisX, thisY = self.physics.body:getPosition()
  return { thisX, thisY }
end

function Bolt:getTransform()
  return self.physics.body.transform
end

--===========================================
-- Animation control
--===========================================

function Bolt:getAnimation( name )
  return self.animations[name]
end

function Bolt:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function Bolt:startAnimation( name )
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation( name )
  self.currentAnimation:start()
  return self.currentAnimation
end

--===========================================
-- Utility functions, consider these private
--===========================================

function Bolt:destroy()
  self.layer:removeProp( self.prop )
end

function Bolt:addAnimation( name, startFrame, frameCount, time, mode )
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