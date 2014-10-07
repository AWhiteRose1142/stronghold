module( "Index", package.seeall )

local resource_definitions = {
  wallTop = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_top.png', 
    width = 16, height = 16,
  },
  wallMiddle = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_middle.png', 
    width = 16, height = 16,
  },
  wallBase = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_base.png', 
    width = 16, height = 16,
  },
  background = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/background.png', 
    width = 256, height = 128,
  },
  mainMenuBackground = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/main_bg.png', 
    width = 256, height = 128,
  },
  upgradeBackground = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/upgrade_bg.png', 
    width = 256, height = 128,
  },
  buttonActive = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/button_active.png', 
    width = 100, height = 50,
  },
  buttonInactive = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/button_inactive.png', 
    width = 100, height = 50,
  },
  iceIcon = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/ice_icon.png', 
    width = 24, height = 24,
  },
  bowIcon = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/bow_icon.png', 
    width = 24, height = 24,
  },
  wallIcon = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_icon.png', 
    width = 24, height = 24,
  },
  lightningIcon = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/lightning_icon.png', 
    width = 24, height = 24,
  },
  groundTile = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/ground_tile.png',
    width = 16, height = 16,
  },
  ground = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/ground.png',
    width = 512, height = 64,
  },
  arrow= {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/Arrow.png',
    width = 16, height = 16,
  },
  buttonPH = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/button_ph.png',
    width = 32, height = 16,
  },
  archer = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/archer_sheet.png',
    tileMapSize = {5, 1},
    width = 16, height = 16,
  },
  goblin = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/Goblin.png',
    tileMapSize = {9, 1},
    width = 16, height = 16,
  },
  footman = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/footman_sheet.png',
    tileMapSize = {4, 3},
    width = 16, height = 16,
  },
  bolt = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/bolt_sheet.png',
    tileMapSize = {2, 1},
    width = 16, height = 16,
  },
  fireball = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = "img/fireball_sheet.png",
    tileMapSize = {2, 1},
    width = 16, height = 16,
  },
  sorcerer = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/sorcerer_sheet.png',
    tileMapSize = {6, 1},
    width = 16, height = 16,
  },
  orc = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/orc_sheet.png',
    tileMapSize = {9, 1},
    width = 16, height = 16,
  },
  hudFont = {
    type = RESOURCE_TYPE_FONT,
    fileName = "fonts/tuffy.ttf",
    glyphs = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789:,.?!",
    fontSize = 26,
    dpi = 160
  },
  font = {
    type = RESOURCE_TYPE_FONT,
    fileName = "fonts/dpcomic.ttf",
    glyphs = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789:,.?!",
    fontSize = 26,
    dpi = 160
  },
}

function Index:loadDefinitions()
  ResourceDefinitions:setDefinitions( resource_definitions )
end