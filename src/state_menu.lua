local menu = {}

function menu:draw()
  atlas:getSprites()['eyes_angry.png']:drawFull(0,0,0,2,2)
  love.graphics.setFont(fonts.title)
  love.graphics.printf("GET OFF, CAT!",0,64,512,"center")
  love.graphics.setFont(fonts.default)
  love.graphics.printf("[press any button to start]\n\nA game by @josefnpat for Ludum Dare 34\nMissingSentinelSoftware.com",
    0,256,512,"center")
end

function menu:keypressed()
  hump.gamestate.switch(gamestates.game)
end

return menu
