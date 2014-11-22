local class =  require 'libs/middleclass'

FloatyText = class('floatyText')

function FloatyText:initialize( text, layer, position, size )
  self.text = text
  self.layer = layer
  local x, y = unpack( position )
  self.textBox = MOAITextBox.new()
  self.textBox:setFont( ResourceManager:get("font") )
  if size ~= nil then self.textBox:setTextSize( size ) else self.textBox:setTextSize( 22 ) end
  self.textBox:setRect( x - 50, y - 25, x + 50, y + 25 )
  self.textBox:setString( self.text )
  self.textBox:setYFlip( true )
  self.textBox:setAlignment( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
  self.textBox:setColor( 1, .91, .39, 1 )
  --self.textBox:setColor( 100, 91, 39, 1 )
  self.layer:insertProp( self.textBox )
  self.textBox:moveLoc( 0, 100, 0, 1 )
  print( "showing text at " .. x .. " " .. y )
  
  local timer =  MOAITimer.new()
  timer:setMode( MOAITimer.NORMAL )
  timer:setSpan( 1.2 )
  timer:setListener( MOAITimer.EVENT_TIMER_END_SPAN, bind( self, "destroy" ) )
  timer:start()
end

function FloatyText:destroy()
  self.layer:removeProp( self.textBox )
end