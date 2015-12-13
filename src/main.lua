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

function love.load()
  hump.gamestate.registerEvents()
  hump.gamestate.switch(gamestates.game)
end
