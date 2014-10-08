local class = require "libs/middleclass"

Button = class( "button")

function Button:initialize( position, layer, partition, ignoreLayer, text, size )
  self.layer = layer
  self.ignoreLayer = ignoreLayer
  self.partition = partition
  self.ignorePart = ignorePart
  self.activeDeck = ResourceManager:get("buttonActive")
  self.inactiveDeck = ResourceManager:get("buttonInactive")
  
  self.prop = MOAIProp2D.new()
  self.prop:setDeck( self.inactiveDeck )
  self.prop:setLoc( unpack( position ) )
  self.prop:setPriority( 2 )
  self.layer:insertProp( self.prop )
  self.partition:insertProp( self.prop )
  
  local x, y = unpack( position )
  local textBox = MOAITextBox.new()
  textBox:setFont( ResourceManager:get("font") )
  if size ~= nil then textBox:setTextSize( size ) else textBox:setTextSize( 28 ) end
  textBox:setRect( x - 50, y - 25, x + 50, y + 25 )
  textBox:setString( text )
  textBox:setYFlip( true )
  textBox:setAlignment( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
  textBox:setColor( 100, 100, 100, 1 )
  self.ignoreLayer:insertProp( textBox )
end

function Button:setHandler( callback )
  self.callback = callback
end

function Button:onInput( down, onButton )
  if down == true then self:onActive() end
  if down == false and onButton == true then 
    self:onInactive()
    if self.callback ~= nil then self.callback() end
  elseif down == false then
    self:onInactive()
  end
end

function Button:onActive()
  self.prop:setDeck( self.activeDeck )
end

function Button:onInactive()
  self.prop:setDeck( self.inactiveDeck )
end