module( "UpgradeMenu", package.seeall )

local PAD_B = 60
local PAD_R = 100
local BASEPX = -200
local BASEPY = 60
initialized = false

local buttonDefs = {
  wall = {
    pos = { BASEPX, BASEPY },
    name = "wall",
    img = "wallIcon",
    cost = 100,
  },
  archer = {
    pos = { BASEPX, BASEPY - PAD_B },
    name = "archer",
    img = "bowIcon",
    cost = 200,
  },
  lightning = {
    pos = { BASEPX, BASEPY - ( PAD_B * 2 ) },
    name = "lightning",
    img = "lightningIcon",
    cost = 500,
  },
  ice = {
    pos = { BASEPX, BASEPY - ( PAD_B * 3 ) },
    name = "ice",
    img = "iceIcon",
    cost = 500,
  },
}

function UpgradeMenu:initialize( )
  self:setupLayers()
  
  self.font = ResourceManager:get( "font" )
  
  self.background = MOAIProp2D.new()
  self.background:setDeck( ResourceManager:get( "upgradeBackground" ) )
  self.background:setScl( 2.5, 2.5 )
  self.layers.background:insertProp( self.background )
  
  self:setupItems()
  self:setupText()
  self.initialized = true
end

function UpgradeMenu:update()
  self.items.wall.textBox:setString( "x " .. Player.progress.walls )
  self.items.archer.textBox:setString( "x " .. Player.progress.archers )
  self.scoreBox:setString( Player.progress.score .. "gp" )
end

function UpgradeMenu:onInput( )
  local x, y = self.layers.user:wndToWorld(MOAIInputMgr.device.pointer:getLoc ())
  local down = MOAIInputMgr.device.mouseLeft:isDown()
  
  if down == true then self.activeButton = self:pickProp( down, x, y ) end
  if down == false and self.activeButton ~= nil then 
    if self:pickProp( down, x, y ) == nil then
      self.activeButton:onInput( down, false )
    end
    self.activeButton = nil
  end
end

function UpgradeMenu:pickProp( down, x, y )
  --print( "down, x and y vars: " .. tostring( down ) .. " " .. x .. " " .. y )
  local obj = self.partitions.user.propForPoint( self.partitions.user, x, y )
  for key, item in pairs( self.items ) do
    if item.button.prop == obj then
      item.button:onInput( down, true )
      return item.button
    end
  end
  return nil
end

function UpgradeMenu:setupText()
  wx, wy = unpack( buttonDefs.wall.pos )
  wx = wx + 25
  self.items.wall.textBox = self:makeTextBox( 16, { wx - 32, wy - 32, wx + 32, wy + 32 } )
  
  ax, ay = unpack( buttonDefs.archer.pos )
  ax = ax + 25
  self.items.archer.textBox = self:makeTextBox( 16, { ax - 32, ay - 32, ax + 32, ay + 32 } )
  
  sx, sy = 100, 0
  self.scoreBox = self:makeTextBox( 26, { sx - 48, sy - 16, sx + 48, sy + 16 } )
  
  tx, ty = 0, 125
  self.title = self:makeTextBox( 40, { tx - 80, ty - 32, tx + 80, ty + 32 } )
  self.title:setString( "Upgrades" )
end

function UpgradeMenu:setupItems()
  self.items = {}
  self.activeButton = nil
  -- Buttons maken
  for key, btn in pairs( buttonDefs ) do
    self.items[btn.name] = {}
    
    local px, py = unpack( btn.pos )
    local iconDeck = ResourceManager:get( btn.img )
    local iconProp = MOAIProp2D.new()
    iconProp:setDeck( iconDeck )
    iconProp:setLoc( px, py )
    self.layers.user:insertProp( iconProp )
    local button = Button:new( { px + PAD_R, py }, self.layers.user, self.partitions.user, self.layers.ignoreLayer, "buy" )
    
    self.items[btn.name].icon = iconProp
    self.items[btn.name].button = button
    self.items[btn.name].cost = btn.cost
  end
  
  self.items.wall.button:setHandler( 
    function()
      print( "wall button!" )
      if Player.progress.score >= UpgradeMenu.items.wall.cost and Player.progress.walls < 3 then
        Player.progress.score = Player.progress.score - UpgradeMenu.items.wall.cost
        Player.progress.walls = Player.progress.walls + 1
      end
    end
  )
  
  self.items.archer.button:setHandler( 
    function()
      print( "archer button!" )
      if Player.progress.score >= UpgradeMenu.items.archer.cost and Player.progress.walls > Player.progress.archers then
        Player.progress.score = Player.progress.score - UpgradeMenu.items.archer.cost
        Player.progress.archers = Player.progress.archers + 1
      end
    end
  )
  
  if Player.progress.lightning == true then 
    self.items.lightning.icon:setColor( 1, 1, 1, 1 ) 
  else
    self.items.lightning.icon:setColor( 100, 100, 100, 1 )
  end
  self.items.lightning.button:setHandler( 
    function()
      print( "lightning button!" )
      if Player.progress.score >= UpgradeMenu.items.wall.cost and Player.progress.lightning == false then
        Player.progress.score = Player.progress.score - UpgradeMenu.items.wall.cost
        Player.progress.lightning = true
        UpgradeMenu.items.lightning.icon:setColor( 1, 1, 1, 1 )
      end
    end
  )
  
  if Player.progress.iceBolt == true then 
    self.items.ice.icon:setColor( 1, 1, 1, 1 ) 
  else
    self.items.ice.icon:setColor( 100, 100, 100, 1 )
  end
  self.items.ice.button:setHandler( 
    function()
      print( "ice button!" )
      if Player.progress.score >= UpgradeMenu.items.ice.cost and Player.progress.iceBolt == false then
        Player.progress.score = Player.progress.score - UpgradeMenu.items.ice.cost
        Player.progress.iceBolt = true
        UpgradeMenu.items.ice.icon:setColor( 1, 1, 1, 1 )
      end
    end
  )
  
  self.items.nextWave = {}
  self.items.nextWave.button = Button:new( { 100, -100 }, self.layers.user, self.partitions.user, self.layers.ignoreLayer, "next wave" )
  self.items.nextWave.button:setHandler( function()
      Game:startNewState( "level" )
    end
  )
end

function UpgradeMenu:setupLayers()
  self.layers = {}
  self.partitions = {}
  self.layers.user = MOAILayer2D.new()
  self.layers.ignoreLayer = MOAILayer2D.new()
  self.layers.background = MOAILayer2D.new()
  self.partitions.user = MOAIPartition.new()
  self.layers.user:setViewport( gameViewport )
  self.layers.ignoreLayer:setViewport( gameViewport )
  self.layers.background:setViewport( gameViewport )
  self.layers.user:setPartition( self.partitions.user )
  
  
  local renderTable = {
    self.layers.background,
    self.layers.user,
    self.layers.ignoreLayer,
  }
  
  MOAIRenderMgr.setRenderTable( renderTable )
end

function UpgradeMenu:makeTextBox( size, rectangle )
  local textBox = MOAITextBox.new()
  textBox:setFont( self.font )
  textBox:setTextSize( size )
  textBox:setRect( unpack( rectangle ) )
  textBox:setYFlip( true )
  textBox:setAlignment( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
  textBox:setColor( 100, 100, 100, 1 )
  textBox:setString( "test" )
  self.layers.ignoreLayer:insertProp( textBox )
  return textBox
end

function UpgradeMenu:destroy()
  self.initialized = false
  self.activeButton = nil
end