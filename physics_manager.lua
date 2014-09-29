module ( "PhysicsManager", package.seeall )

------------------------------------------------
-- initialize ( string: layer )
-- Initializes the physics engine using 'layer'
-- for debug output. If layer is nil then no
-- layer is set.
------------------------------------------------
function PhysicsManager:initialize ( layer )
  
  -- Create the Box2D world
  self.world = MOAIBox2DWorld.new ()
  
  -- We set the relationship between 
  -- world units and meters.
  -- We calculated this value using
  -- a proportion from the main
  -- character asset.
  self.world:setUnitsToMeters ( 1/38 )
  
  -- We set the gravity to something
  -- that is not realistic but is useful
  -- for our game
  self.world:setGravity ( 0, -100 )
  
  -- We start the simulation so objects
  -- begin to interact.
  self.world:start ()
  -- If a debug layer is passed use
  -- it to display the objects that
  -- our world is using in the 
  -- simulation.
  if layer then
    self.layer = layer
    layer:setBox2DWorld ( self.world )
  end
  
  --self.corout = MOAICoroutine.new()
  --self.corout.run( PhysicsManager:update() )
  --self.killList = nil
  --Game.corout.attach( self.world )
  
end

function PhysicsManager:destroy()
  self.world:stop()
  if self.layer ~= nil then self.layer = nil end
  self.world = nil
end

-- NOT USED, SHIT DOESNT WORK
function PhysicsManager:sceduleForRemoval( body )
  if self.killList then
    table.insert( self.killList, body )
  else
    self.killList = {}
    table.insert( self.killList, body )
  end
end

function PhysicsManager:update()
  if self.killList ~= nil then
    for key, kill in pairs( self.killList ) do
      kill.physics.body.destroy()
    end
  end
end
