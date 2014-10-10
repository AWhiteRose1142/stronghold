local class = require 'libs/middleclass'

Manabar = class('manabar')

function Manabar:initialize( startPos, width, height, layer, opacity )
  self.startPos = startPos
  self.width = width
  self.height = height
  self.length = width
  self.opacity = opacity
  self.layer = layer
  self.scriptDeck = MOAIScriptDeck.new ()
  self.scriptDeck:setRect ( 
    -( WORLDRES_X / 2 ), 
    -( WORLDRES_Y / 2 ), 
    ( WORLDRES_X / 2 ), 
    ( WORLDRES_Y / 2 ) 
  )
  self.scriptDeck:setDrawCallback( bind( self, "draw" ) )

  self.prop = MOAIProp2D.new ()
  self.prop:setColor( .4, .4, 1, self.opacity )
  self.prop:setDeck( self.scriptDeck )
  layer:insertProp( self.prop )
end

function Manabar:update()
  self.width = ( self.length / 100 ) * Player.progress.mana
end

function Manabar:draw( index, xOff, yOff, xFlip, yFlip )
  local dims = {
    self.startPos[1],
    self.startPos[2] - (self.height / 2),
    self.startPos[1] + self.width,
    self.startPos[2] + (self.height / 2),
  }
  MOAIDraw.fillRect( unpack( dims ) )
end

function Manabar:destroy()
  self.layer:removeProp( self.prop )
end