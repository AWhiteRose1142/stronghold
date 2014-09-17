function footman( x, y, layer )
  local texture = MOAIGfxQuad2D.new()
  texture:setTexture('res/img/footman.png')
  texture:setRect( -32, -32, 32, 32 )
  
  local prop = MOAIProp2D.new()
  prop:setDeck( texture )
  prop:setLoc( x, y )
  
  layer:insertProp( prop )
  return prop
end

function move()
  
end