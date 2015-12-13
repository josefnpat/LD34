math.randomseed(os.time())

hump = {
  gamestate = require "gamestate",
}

gamestates = {
  game = require "state_game",
}

lib = {
  json = require "json",
  ilovetexpack = require "ilovetexpack",
}

fonts = {
  default = love.graphics.newFont("IndieFlower.ttf",24)
}

colors = {
  text_background = {0,0,0,191},
  text = {255,255,255},
  reset = {255,255,255},
  death = {255,0,0},
}

atlas = lib.ilovetexpack.render("atlas")
atlas:getImage():setFilter("nearest","nearest")

function love.load()
  hump.gamestate.registerEvents()
  hump.gamestate.switch(gamestates.game)
end
