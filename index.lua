module( "Index", package.seeall )

local resource_definitions = {
  wallTop = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_top.png', 
    width = 48, height = 48,
  },
  wallMiddle = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_middle.png', 
    width = 48, height = 48,
  },
  wallBase = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wall_base.png', 
    width = 48, height = 48,
  },
  towerTop = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wizard_tower_top.png', 
    width = 48, height = 48,
  },
  towerMiddle = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wizard_tower_middle.png', 
    width = 48, height = 48,
  },
  towerBase = {
    type = RESOURCE_TYPE_IMAGE, 
    fileName = 'img/wizard_tower_base.png', 
    width = 48, height = 48,
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
    width = 700, height = 64,
  },
  arrow = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/arrow.png',
    width = 16, height = 16,
  },
  tutFireball = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/tutorial_fireball.png',
    width = 640, height = 360,
  },
  tutLightning = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/tutorial_lightning.png',
    width = 640, height = 360,
  },
  tutIce = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/tutorial_ice.png',
    width = 640, height = 360,
  },
  tutArcher = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/tutorial_archer.png',
    width = 640, height = 360,
  },
  logo = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/logo.png',
    width = 128, height = 64,
  },
  archer = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/archer_32_sheet.png',
    tileMapSize = {4, 1},
    width = 32, height = 32,
  },
  goblin = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/Goblin.png',
    tileMapSize = {9, 1},
    width = 32, height = 32,
  },
  troll = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/serpent.png',
    tileMapSize = {7, 1},
    width = 32, height = 32,
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
  iceBolt = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = "img/icebolt_sheet.png",
    tileMapSize = {2, 1},
    width = 16, height = 16,
  },
  sorcerer = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/wizard_32_sheet.png',
    tileMapSize = {6, 1},
    width = 32, height = 32,
  },
  orc = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/orc_sheet.png',
    tileMapSize = {9, 1},
    width = 32, height = 32,
  },
  imp = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/imp_sheet.png',
    tileMapSize = {7, 1},
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
  dying = {
    type = RESOURCE_TYPE_SOUND,
    fileName = "sfx/dying.ogg",
    loop = false,
    volume = 0.5
  },
  explosion = {
    type = RESOURCE_TYPE_SOUND,
    fileName = "sfx/explosion.ogg",
    loop = false,
    volume = 0.5
  },
  crumble = {
    type = RESOURCE_TYPE_SOUND,
    fileName = "sfx/hit_and_crumble.ogg",
    loop = false,
    volume = 0.5
  },
  punch = {
    type = RESOURCE_TYPE_SOUND,
    fileName = "sfx/punch.ogg",
    loop = false,
    volume = 0.5
  },
  sword = {
    type = RESOURCE_TYPE_SOUND,
    fileName = "sfx/sword.ogg",
    loop = false,
    volume = 0.5
  },
  zap = {
    type = RESOURCE_TYPE_SOUND,
    fileName = "sfx/zap.ogg",
    loop = false,
    volume = 0.5
  },
  level = {
    type = RESOURCE_TYPE_SOUND,
    fileName = "sfx/level.ogg",
    loop = true,
    volume = 0.8
  },
  main = {
    type = RESOURCE_TYPE_SOUND,
    fileName = "sfx/main.ogg",
    loop = true,
    volume = 0.8
  }
}

function Index:loadDefinitions()
  ResourceDefinitions:setDefinitions( resource_definitions )
end