local game = {}

function game:init()
  self.atlas = lib.ilovetexpack.render("atlas")
  self.atlas:getImage():setFilter("nearest","nearest")
  self.background = love.graphics.newImage("background.png")

  self.paws = {"normal"}
  self.eyes = {"angry","neutral","open","wat"}
  self.mouth = {"eating","open","wat"}
  self.food = {"asparagus","bag","beer","boot","bowl","can","fish","goebbels",
    "pizza","porcupine","sonic","squirrel"}

end

function game:randomFeatures()
  self.cpaws = "paws_"..self.paws[math.random(#self.paws)]..".png"
  self.ceyes = "eyes_"..self.eyes[math.random(#self.eyes)]..".png"
  self.cmouth = "mouth_normal.png"
  self.cfood = "food_"..self.food[math.random(#self.food)]..".png"
  self.csize = (self.csize + 0.01)%1
end

function game:enter()
  self.food_offset = 0
  self.food_direction = 1

  self.pet_offset = 0.5
  self.pet_direction = 1

  self.csize = 0
  self:randomFeatures()

  self.ceating = 0

  self.cangry = 0
end

function game:update(dt)

  self.cangry = math.min(1,self.cangry + dt/2)

  self.food_offset = self.food_offset + dt*self.food_direction*10

  if self.food_offset > 1 then
    self.food_offset = 1
    self.food_direction = -1
    self:randomFeatures()
    self.ceating = 1
  elseif self.food_offset < 0 then
    self.food_offset = 0
    self.food_direction = 1
  end

  self.pet_offset = self.pet_offset + dt*self.pet_direction

  if self.pet_offset > 1 then
    self.pet_offset = 1
    self.pet_direction = -1
    self.cangry = 0
  elseif self.pet_offset < 0 then
    self.pet_offset = 0
    self.pet_direction = 1
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

  love.graphics.draw(self.background,0,0,0,2,2)
  self.atlas:getSprites()['tail_normal.png']:drawFull(0,0,0,2,2)

  local bi = self.atlas:getSprites()['body.png']
  bi:draw(
    256+math.random(-5,5)*self.cangry,
    256+math.random(-5,5)*self.cangry,
    0,2+self.csize*4,2+self.csize*4,
    bi:getWidth()/2,bi:getHeight()/2
  )

  self.atlas:getSprites()[self.cpaws]:drawFull(0,0,0,2,2)
  self.atlas:getSprites()[self.ceyes]:drawFull(0,0,0,2,2)

  if self.cangry > 0.75 then
    self.atlas:getSprites()['eyes_brow.png']:drawFull(0,0,0,2,2)
  end
  self.atlas:getSprites()['nose_normal.png']:drawFull(
    self.cangry*math.random(-2,2),
    self.cangry*math.random(-2,2),0,2,2)

  self.atlas:getSprites()[self.cmouth]:drawFull(0,0,0,2,2)

  local pet_offset_px = self.tween_pet(self.pet_offset) * 128-128

  self.atlas:getSprites()['hand_upper.png']:drawFull(0,pet_offset_px,0,2,2)

  local hl = self.atlas:getSprites()['hand_lower.png']

  local food_offset_px = (self.tween_food(self.food_offset)-1)*hl:getWidth()
  if self.food_direction == 1 then
    self.atlas:getSprites()[self.cfood]:drawFull(food_offset_px,0,0,2,2)
  end

  hl:drawFull(food_offset_px,0,0,2,2)

  if self.csize >= 0.95 then
    self.atlas:getSprites()['kaboom.png']:drawFull(0,0,0,2,2)
  end

end

function game:keypressed()
  self:init()
end

return game
