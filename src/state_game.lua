local game = {
  bind = {
    feed = function() return love.keyboard.isDown("a") end,
    pet = function() return love.keyboard.isDown("l") end,
  }
}

function game:init()
  self.background = love.graphics.newImage("background.png")

  self.paws = {"normal"}
  self.eyes = {"angry","neutral","open","wat"}
  self.mouth = {"eating","open","wat"}
  self.food = {"asparagus","bag","beer","boot","bowl","can","fish","goebbels",
    "pizza","porcupine","sonic","squirrel"}

  self.debug = false

  self.cpaws = "paws_"..self.paws[math.random(#self.paws)]..".png"
end

function game:feedCat()
  self.cfood = "food_"..self.food[math.random(#self.food)]..".png"
  self.csize = math.min(1,self.csize + 0.025)
end

function game:enter()

  self.dead = false
  self.death_fade = 0
  self.game_over = 0

  self.cfood = "food_bowl.png"
  self.food_offset = 0
  self.food_direction = 1

  self.pet_offset = 0.5
  self.pet_direction = 1

  self.csize = 0

  self.ceating = 0

  self.cangry = 0

  self._message_dt = 5
  self._message = "Feed the cat with [A] until it gets off your laptop.\nPet the cat with [L] when it gets angry."
end

function game:setMessage(msg)
  self._message = msg
  self._message_dt = 1
end

function game:isMessageVisable()
  return self._message ~= 0
end

function game:update(dt)

  if not self.dead then
    self._message_dt = math.max(0,self._message_dt - dt)
  end

  if not self.dead and game.bind.feed() or self.food_direction == -1 then
    self.food_offset = self.food_offset + dt*self.food_direction*2
  else
    self.food_offset = self.food_offset - dt
  end

  if self.food_offset > 1 then
    self.food_offset = 1
    self.food_direction = -1
    if self.ceating == 0 then
      self:feedCat()
      self.ceating = 1.5
      self:setMessage("Om nom nom nom")
    else
      self:feedCat()
      self.cangry = math.min(1,self.cangry + 0.7)
      self:setMessage("Don't feed the cat when it's mouth is full!")
    end
  elseif self.food_offset < 0 then
    self.food_offset = 0
    self.food_direction = 1
  end

  if not self.dead and game.bind.pet() or self.pet_direction == -1 then
    self.pet_offset = self.pet_offset + dt*self.pet_direction*2
  else
    self.pet_offset = self.pet_offset - dt*2
  end

  if self.pet_offset > 1 then
    self.pet_offset = 1
    self.pet_direction = -1
    if self.cangry < 0.1 then
      self:setMessage("Don't pet the cat when it's not angry!")
      self.cangry = math.min(1,self.cangry+0.7)
    else
      self:setMessage("You calm the cat.")
      self.cangry = math.max(0,self.cangry-0.2)
    end
  elseif self.pet_offset < 0 then
    self.pet_offset = 0
    self.pet_direction = 1
  end

  self.cangry = math.min(1,self.cangry + dt/30)

  if self.csize >= 1 then
    self.dead = true
    self:setMessage("You Win!\n(The cat explodes and kills you.)")
  end

  if self.cangry >= 1 then
    self.dead = true
    self:setMessage("You Lose!\n(The cat is so angry, it kills you. Sorry!)")
  end


  if self.dead then
    self.death_fade = math.min(1,self.death_fade + dt)
    self.game_over = self.game_over + dt
    if self.game_over > 3 then
      hump.gamestate.switch(gamestates.menu)
    end
  end

  self.ceating = math.max(0,self.ceating - dt)

  if self.ceating == 0 then
    self.cmouth = "mouth_open.png"
  else
    self.cmouth = math.floor(self.ceating*10)%2==1 and
      "mouth_eating.png" or "mouth_wat.png"
  end

  if self.cangry > 0.75 then
    self.ceyes = "eyes_angry.png"
  elseif self.cangry > 0.5 then
    self.ceyes = "eyes_wat.png"
  elseif self.cangry > 0.25 then
    self.ceyes = "eyes_neutral.png"
  else
    self.ceyes = "eyes_open.png"
  end

end

function game.tween_pet(s)
  local a,b = 7.5625, 1/2.75
  return math.min(
    a*s^2,
    a*(s-1.5*b)^2 + .75,
    a*(s-2.25*b)^2 + .9375,
    a*(s-2.625*b)^2 + .984375)
end

function game.tween_food(s)
  return s*s
end

function game:draw()

  love.graphics.setFont(fonts.default)

  love.graphics.draw(self.background,0,0,0,2,2)
  atlas:getSprites()['tail_normal.png']:drawFull(0,0,0,2,2)

  local bi = atlas:getSprites()['body.png']
  bi:draw(
    256+math.random(-5,5)*self.cangry,
    256+math.random(-5,5)*self.cangry,
    0,2+self.csize*4,2+self.csize*4,
    bi:getWidth()/2,bi:getHeight()/2
  )

  atlas:getSprites()[self.cpaws]:drawFull(0,0,0,2,2)
  atlas:getSprites()[self.ceyes]:drawFull(0,0,0,2,2)

  if self.cangry > 0.75 then
    atlas:getSprites()['eyes_brow.png']:drawFull(0,0,0,2,2)
  end
  atlas:getSprites()['nose_normal.png']:drawFull(
    self.cangry*math.random(-2,2),
    self.cangry*math.random(-2,2),0,2,2)

  atlas:getSprites()[self.cmouth]:drawFull(0,0,0,2,2)

  local pet_offset_px = self.tween_pet(self.pet_offset) * 128-128

  atlas:getSprites()['hand_upper.png']:drawFull(0,pet_offset_px,0,2,2)

  local hl = atlas:getSprites()['hand_lower.png']

  local food_offset_px = (self.tween_food(self.food_offset)-1)*hl:getWidth()
  if self.food_direction == 1 then
    atlas:getSprites()[self.cfood]:drawFull(food_offset_px,0,0,2,2)
  end

  hl:drawFull(food_offset_px,0,0,2,2)

  if self.csize >= 1 then
    atlas:getSprites()['kaboom.png']:drawFull(0,0,0,2,2)
  end

  love.graphics.setColor(
    colors.death[1],
    colors.death[2],
    colors.death[3],
    self.death_fade*255)
  love.graphics.rectangle("fill",0,0,512,512)
  love.graphics.setColor(colors.reset)

  if self._message_dt > 0 then
    love.graphics.setColor(colors.text_background)
    local width,lines = fonts.default:getWrap(self._message,512)
    local height = fonts.default:getHeight()
    love.graphics.rectangle("fill",0,256+128-8,512,lines*height+16)
    love.graphics.setColor(colors.text)
    love.graphics.printf(self._message,0,256+128,512,"center")
  end

  if self.debug then
    love.graphics.print("anger:"..self.cangry.."\n"..
      "size:"..self.csize.."\n"..
      "message_dt:"..self._message_dt.."\n"..
      "eating:"..self.ceating,8,8)
  end

end

function game:keypressed(key)
  if key == "`" then
    self.debug = not self.debug
  end
end

return game
