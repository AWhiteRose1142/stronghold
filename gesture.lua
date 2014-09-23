module( "Gesture", package.seeall )

function Gesture:click()
  -- calls if IsMouseDown
  print "click"
          clickEntity = Game:pickEntity(MOAIInputMgr.device.pointer:getLoc())
          clickEntity:action()
end