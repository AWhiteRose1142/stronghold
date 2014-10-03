local class = require 'libs/middleclass'

Line = class('line')

function Line:initialize( startPos, layer )
  self.points = {}
  self.layer = layer
  table.insert( self.points, startPos )
  self.scriptDeck = MOAIScriptDeck.new ()
  self.scriptDeck:setRect ( 
    -( WORLDRES_X / 2 ), 
    -( WORLDRES_Y / 2 ), 
    ( WORLDRES_X / 2 ), 
    ( WORLDRES_Y / 2 ) 
  )
  self.scriptDeck:setDrawCallback( bind( self, "draw" ) )

  self.prop = MOAIProp2D.new ()
  self.prop:setDeck( self.scriptDeck )
  layer:insertProp( self.prop )
end

function Line:update()
  
end

function Line:draw( index, xOff, yOff, xFlip, yFlip )
  local drawPoints = {}
  for key, point in pairs(self.points ) do
    table.insert( drawPoints, point[1] )
    table.insert( drawPoints, point[2] )
  end
  MOAIDraw.drawLine( drawPoints )
end

function Line:addPoint( position )
  print( "adding a point" )
  table.insert( self.points, position )
end

function Line:setPoints( positions )
  self.points = nil
  self.points = position
end

function Line:setLastPoint( position )
  local n = table.getn( self.points )
  self.points[n] = position
end

function Line:getPoints()
  return self.points
end

function Line:getLastPoint()
  return self.points[ table.getn( self.points ) ]
end

function Line:destroy()
  self.layer:removeProp( self.prop )
end