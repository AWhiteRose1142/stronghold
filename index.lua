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
  button = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/button-ph.png',
    width = 60, height = 20,
  },
  arrow = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'img/Arrow.png',
    width = 16, height = 16,
  },
  archer = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'img/archer_sheet.png',
    tileMapSize = {5, 1},
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
  hudFont = {
    type = RESOURCE_TYPE_FONT,
    fileName = "fonts/tuffy.ttf",
    glyphs = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789,.?!",
    fontSize = 26,
    dpi = 160
  },
}

function Index:loadDefinitions()
  ResourceDefinitions:setDefinitions( resource_definitions )
end