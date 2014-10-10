module( "HUD", package.seeall )

function HUD:initialize()
  self.viewport = MOAIViewport.new()
  viewport:setSize( SCREENRES_X, SCREENRES_Y )
  viewport:setScale( SCREENRES_X, -SCREENRES_Y )
  viewport:setOffset( -1, 1 )
  
  self.layer = MOAILayer2D.new()
  self.layer:setViewport( self.viewport )
  -- Render the layer
  local renderTable = MOAIRenderMgr.getRenderTable()
  -- Ohja, table is voor alle array gerelateerde utilities. Maf.
  table.insert( renderTable, self.layer )
  MOAIRenderMgr.setRenderTable( renderTable )
  
  self:initializeDebugHud()
end

function HUD:initializeDebugHud()
  self.font = MOAIFont.new()
  self.font = ResourceManager:get( "font" )
  self.score = self:newTextBox( 36, { 10, 10, 200, 50 } )
  self.mana = self:newTextBox( 36, { 10, 60, 100, 120 } )
  self.mana:setString( "MANA: " )
  self.manaBarUnder = Manabar:new( { 110, 75 }, 250, 30, self.layer, .7 )
  self.manaBar = Manabar:new( { 110, 75 }, 250, 30, self.layer, 1 )
end

function HUD:newTextBox( size, rectangle )
  local textBox = MOAITextBox.new()
  textBox:setFont( self.font )
  textBox:setTextSize( size )
  textBox:setRect( unpack( rectangle ) )
  textBox:setColor( .4, .4, .4, 1 )
  layer:insertProp( textBox )
  return textBox
end

function HUD:update()
  self.manaBar:update()
  local scoreString = ( "SCORE: " .. Player.progress.score )
  self.score:setString( scoreString )
end

function HUD:destroy()
  self.layer:removeProp( self.score )
  self.layer:removeProp( self.mana )
end
  