function wall( x, y, height, layer )
  local wallTexture = MOAIGfxQuad2D.new()
  wallTexture:setTexture('res/img/wall.png')
  wallTexture:setRect( -32, -32, 32, 32 )
  
  local wallTopTexture = MOAIGfxQuad2D.new()
  wallTopTexture:setTexture('res/img/wall-top.png')
  wallTopTexture:setRect( -32, -32, 32, 32 )
  
  for i = 1, height, 1 do
    local prop = MOAIProp2D.new()
    prop:setDeck( wallTexture )
    prop:setLoc( x, y + ( 64 * (i-1) ) )
    layer:insertProp( prop )
    print( 'Placing wall at' .. tostring(64 * (i-1)) )
  end
  
  local wallTopProp = MOAIProp2D.new()
  wallTopProp:setDeck( wallTopTexture )
  wallTopProp:setLoc( x,  y + ( 64 * height ) )
  layer:insertProp( wallTopProp )
    
end