module ( "Upgrade", package.seeall )

MOAIInputMgr.device.mouseLeft:setCallback( 
  function( isMouseDown )
    if MOAIInputMgr.device.mouseLeft:isDown() then
      Upgrade:tapped()
    end
  end)

function Upgrade:initialize()
  self.entities = {}
  self.buttonCount = 1
  
  for a = 1, 3 do
    for b = 1, 4 do
      local button = Button:new( { (b * 180), (a * 90) }, Game.layers.user, self.buttonCount )
      table.insert( self.entities, button )
      buttonCount = self.buttonCount + 1
    end
  end
  self:loadProgress()
end

function Upgrade:tapped()
  local button = self.entities:propForPoint( MOAIInputMgr.device.pointer:getLoc() )
  local upgrade = button.id
  print ( upgrade )
end

function Upgrade:loadProgress()
  --Should load player upgrade progress
  --Could be shaped like (2/3) or (1/5)
end