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
  self.font = ResourceManager:get( "hudFont" )
  self.score = self:newDebugTextBox( 30, { 10, 10, 100, 50 } )
end

function HUD:newDebugTextBox( size, rectangle )
  local textBox = MOAITextBox.new()
  textBox:setFont( self.font )
  textBox:setTextSize( size )
  textBox:setRect( unpack( rectangle ) )
  layer:insertProp( textBox )
  return textBox
end

function HUD:update()
  local string = ( "SCORE" .. " " .. Level.score )
  self.score:setString( string )
end
  