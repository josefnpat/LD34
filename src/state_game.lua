local game = {}

function game.init()
  game.atlas = lib.ilovetexpack.render("atlas")
end

function game.draw()
  for _,sprite in pairs(game.atlas:getSprites()) do
    sprite:draw()
  end
end

return game
