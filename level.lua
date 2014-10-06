module( "Level", package.seeall )

GROUND_LEVEL = -120
initialized = false

--==================================================
-- Basic objects that are the same for every level
--==================================================

-- These are definitions for the physics. The category and mask Bits are to prevent units from bumping into eachother.
-- Please use cat & mask 4 & 2 for walls and groundstuff, and use 2 & 4 for units like footmen
local base_objects = {
  floor = {
    type = MOAIBox2DBody.STATIC,
    position = { 0, GROUND_LEVEL - 10 },
    friction = 0,
    size = { 2 * WORLDRES_X, 10 },
    categoryBits = 0x04,
    maskBits = 0x02,
  },
}

function Level:initialize( )
  self.score = 1
  -- For all entites so we can look them up or update them
  self.entities = {}
  -- For all enemy entities
  self.enemyEntities = {
    footmen = {},
    goblins = {},
    orcs = {},
  }
  -- For all entities that belong to the player
  self.playerEntities = {
    walls = {},
    sorcerer = {},
    tower = {},
    archers = {},
  }
  self.objects = {}
  
  -- Setup of the level's layers and camera
  self.camera = MOAICamera2D.new()
  self:setupLayers()
  
  HUD:initialize( )
  PhysicsManager:initialize( Level.layers.active )
  Gesture:initialize( self.layers, self.partitions )
  
  -- This is mostly for debugging purposes.
  InputManager:initialize()
  WaveGenerator:initialize( 1, 1 )
  
  self:loadBackground()
  self:loadScene()
  self:loadEntities()
  WaveGenerator:newWave()
  self.initialized = true
end

--=============================================================
-- Update() is called by the gameLoop and updates all entities
--=============================================================

function Level:update()
  -- Doet nu nog niets.
  for key, entity in pairs( self.entities ) do
    --print( "updating: " .. entity.type )
    entity:update()
  end
  Player:update()
  Gesture:update()
  HUD:update()
end

function Level:onInput( down, x, y )
  if Gesture.initialized == false then return end
  -- Mouse down
  if MOAIInputMgr.device.mouseLeft:isDown() then Gesture:onMouseDown() end
  -- Mouse up
  if MOAIInputMgr.device.mouseLeft:isUp() then Gesture:onMouseUp() end
end

--==================================================
-- Setting up
--==================================================

function Level:setupLayers()
  self.layers = {}
  self.layers.background = MOAILayer2D.new()
  self.layers.active = MOAILayer2D.new()
  self.layers.user = MOAILayer2D.new()
  
  -- Set the viewport and camera for each layer
  for key, layer in pairs ( self.layers ) do
    layer:setViewport( gameViewport )
    layer:setCamera( self.camera )
  end
  
  -- Create a table with the layers in order
  local renderTable = {
    self.layers.background,
    self.layers.active,
    self.layers.user
  }
  
  -- Set up partitions
  self.partitions = {}
  self.partitions.active = MOAIPartition.new()
  self.layers.active:setPartition( self.partitions.active )
  
  -- And pass them to the render manager
  MOAIRenderMgr.setRenderTable( renderTable )
end

function Level:loadEntities()
  startX = -170
  
  for i = 0, 3 do
    Wall:new( i + 1 , { startX - (i * 16), GROUND_LEVEL }, Level.layers.active )
  end
  
  -- Should be initialized on it's own tower
  Sorcerer:new( { 0, 0 }, Level.layers.active )
  
  local archer = Archer:new(
    { 50, 50 }, 
    Level.layers.active, 
    Level.partitions.active 
  )
  self.playerEntities.walls[2]:mountEntity( archer )
  self.playerEntities.walls[4]:mountEntity( self.playerEntities.sorcerer[1] )
  
  --Footman:new( { -100, GROUND_LEVEL }, self.layers.active )
  --Orc:new( { -80, GROUND_LEVEL }, self.layers.active )
  --Goblin:new( { 100, GROUND_LEVEL }, self.layers.active )
end

-- Hier wordt nog ook de grond ingeladen.
function Level:loadBackground()
  self.backgroundDeck = ResourceManager:get( 'background' )
  
  -- Make the prop
  self.backgroundProp = MOAIProp2D.new()
  self.backgroundProp:setDeck( self.backgroundDeck )
  self.backgroundProp:setScl( 2.5, 2.5 )
  self.layers.background:insertProp( self.backgroundProp )

  self.groundProp = MOAIProp2D.new()
  self.groundProp:setDeck( ResourceManager:get( 'ground' ) )
  self.groundProp:setLoc( 0, GROUND_LEVEL - 36 )
  Level.layers.background:insertProp( self.groundProp )
end

function Level:loadScene()
  for key, attr in pairs( base_objects ) do
    local body = PhysicsManager.world:addBody( attr.type )
    body:setTransform( unpack( attr.position ) )
    width, height = unpack( attr.size )
    local fixture = body:addRect( - width / 2, - height / 2, width / 2, height / 2 )
    fixture:setFriction( attr.friction )
    -- Filter zetten. Zorgt ervoor dat bijv footmen niet met elkaar maar wel met de grond en muur colliden.
    fixture:setFilter( attr.categoryBits, attr.maskBits )
    self.objects[key] = { body = body, fixture = fixture }
  end
end

function Level:footmanSpawner( amount )
  for i = 1, amount do
    Footman:new( { 0 + ( 16 * amount ), GROUND_LEVEL }, Level.layers.active )
  end
end

function Level:orcSpawner( amount )
  for i = 1, amount do
    Orc:new( { 0 + ( 16 * amount ), GROUND_LEVEL }, Level.layers.active )
  end
end

--==========================================
-- Loads enemies and player stuff
--==========================================

function Level:loadEnemies( enemyDefs )
  for key, def in pairs( enemyDefs.footmen ) do
    local footman = Footman:new( def.position, Level.layers.active, def.health )
  end
  
  for key, def in pairs( enemyDefs.orcs ) do
    local orc = Orc:new( def.position, Level.layers.active, def.health )
  end
  
  for key, def in pairs( enemyDefs.goblins ) do
    -- make goblin
  end
end

function Level:loadPlayer( playerDefs )
  self.score = playerDefs.stats.score
  
  for key, def in pairs( playerDefs.entities.walls ) do
    Wall:new( def.height, def.position, Level.layers.active, def.health )
  end
  
  for key, def in pairs( playerDefs.entities.archers ) do
    local archer = Archer:new( def.position, Level.layers.active, def.health )
  end
  
  for key, def in pairs( playerDefs.entities.tower ) do
    local tower = Tower:new( def.position, Level.layers.active, def.health )
  end
  
  for key, def in pairs( playerDefs.entities.sorcerer ) do
    local sorcerer = Sorcerer:new( 
      self.playerEntities.walls[3]:getTransform(), 
      { self.playerEntities.walls[3]:getTopLoc() },
      Level.layers.active, 
      Level.partitions.active    
    )
  end
  
  if sorcerer ~= nil then
    Sorcerer:new( 
      self.playerEntities.walls[3]:getTransform(), 
      { self.playerEntities.walls[3]:getTopLoc() },
      Level.layers.active, 
      Level.partitions.active    
    )
  end
end

--====================================================
-- Loading, saving & destroying
--====================================================

function Level:destroy()
  
  -- destroy background
  Level.layers.background:removeProp( self.backgroundProp )
  self.backgroundProp = nil
  Level.layers.background:removeProp( self.groundProp )
  self.groundProp = nil
  
  -- destroy all entities
  for key, entity in pairs( self.entities ) do
    entity:destroy()
  end
  
  -- Destroy the gestures
  Gesture:destroy()
  -- Destroy the physics world ( MUAHAHAHAHA )
  PhysicsManager:destroy()
  
  -- Set own variables to nil
  self.score = nil
  self.initialized = false
end

function Level:loadLevel( levelDefinition )
  -- Load the savefile
  local fullFileName = SAVE_FILE_NAME .. ".lua"
	local workingDir
  local saveData = nil
	
  -- Code for when we're running this on a device
	if DEVICE then
		workingDir = MOAIFileSystem.getWorkingDirectory ()
		MOAIFileSystem.setWorkingDirectory ( MOAIEnvironment.documentDirectory )
	end
	
	if MOAIFileSystem.checkFileExists ( fullFileName ) then
    print ("Loading file: " .. fullFileName)
		local file = io.open ( fullFileName, 'rb' )
		saveData = dofile ( fullFileName )
		self.fileexist = true
	else
    print ("Savefile does not exist")
    return
	end

	if DEVICE then
		MOAIFileSystem.setWorkingDirectory ( workingDir )
	end
  
  -- initialize level
  self.score = saveData.player.score
  
  PhysicsManager:initialize( Level.layers.active )
  Gesture:initialize()
  
  self:loadBackground()
  self:loadScene()
  
  -- instantiate all player entities
  self:loadPlayer( saveData.player )
  
  -- instantiate all new entities
  self:loadEnemies( saveData.enemyEntities )
  
  self.initialized = true
end

function Level:saveLevel()
  for key, entity in pairs( self.entities ) do
    print( "saving: " .. entity.type )
  end
  
  local saveDefinition = {}
  saveDefinition.enemyEntities = {
    footmen = {},
    orcs = {},
    goblins = {},
  }
  
  for key, enemyType in pairs( self.enemyEntities ) do
    for key, enemy in pairs( enemyType ) do
      print( "saving enemy: " .. enemy.type )
      local eDef = {
        type = enemy.type,
        health = enemy.health,
        position = enemy:getPosition(),
      }
      local tableType = "notable"
      if enemy.type == "footman"  then tableType = "footmen"   end
      if enemy.type == "orc"      then tableType = "orcs"      end
      if enemy.type == "goblin" then tableType = "goblins" end
      table.insert( saveDefinition.enemyEntities[tableType], eDef )
    end
  end
  
  saveDefinition.player = {    
    stats = {
      score = self.score,
    },
    entities = {
      tower = {},
      sorcerer = {},
      walls = {},
      archers = {},
    },
  }
  
  for key, entityType in pairs( self.playerEntities ) do
    for key, entity in pairs( entityType ) do
      local eDef = {
        type = entity.type,
        health = entity.health,
        position = entity:getPosition(),
      }
      local tableType = "notable"
      if entity.type == "wall"   then 
        eDef.height = entity.height
        tableType = "walls"   
      end
      if entity.type == "archer" then tableType = "archers" end
      if entity.type == "sorcerer" then tableType = "sorcerer" end
      if entity.type == "tower" then tableType = "tower" end
      table.insert( saveDefinition.player.entities[tableType], eDef )
    end
  end
  
  -- COPIED FILESAVING STUFF
  -- Filename for the save
  local fullFileName = SAVE_FILE_NAME .. ".lua"
	local serializer = MOAISerializer.new ()

	serializer:serialize ( saveDefinition )
	local gamestateStr = serializer:exportToString ()
	
	print ("Saving file: " .. fullFileName)
	local file = io.open ( fullFileName, 'wb' )
	file:write ( gamestateStr )
	file:close ()
		
end

--====================================================
-- Utility functions
--====================================================

-- Takes { x, y }, { x, y }
function Level:getEntitiesNearPos( position, tolerance )
  posX, posY = unpack( position  )
  tolX, tolY = unpack( tolerance )
  local closeEntities = {}
  for key, entity in pairs( self.entities ) do
    local entityX, entityY = unpack( entity:getPosition() )
    if math.abs( entityX - posX ) <= tolX and math.abs( entityY - posY ) <= tolY then
      --print( tostring( entityX - posX ) .. "tolerance: " .. tostring( tolX ) )
      table.insert( closeEntities, entity )
    end
  end
  return closeEntities
end

function Level:getEntityFromFixture( fixture )
  for key, entity in pairs( self.entities ) do
    if entity.physics.fixture == fixture then
      return entity
    end
  end
  return nil
end

function Level:removeEntity( killMe )
  for i = 1, table.getn( self.entities ) do
    if self.entities[i] == killMe then
      table.remove( self.entities, i )
    end
  end
end

function Level:printEntities()
  for key, entity in pairs( self.entities ) do
    print( entity.type )
  end
end

function Level:spawnBolts( position )
  for i = 1, 6 do
    Bolt:new( { position[1] + math.random( -30, 30 ), GROUND_LEVEL + math.random( 30 ) }, Level.layers.active )
  end
end