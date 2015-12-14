local s = {
  music = love.audio.newSource("assets/music.ogg"),
  angry = {
    love.audio.newSource("assets/angry1.ogg"),
    love.audio.newSource("assets/angry2.ogg"),
    love.audio.newSource("assets/angry3.ogg"),
    love.audio.newSource("assets/angry4.ogg"),
  },
  eat = {
    love.audio.newSource("assets/eating1.ogg"),
    love.audio.newSource("assets/eating2.ogg"),
    love.audio.newSource("assets/eating3.ogg"),
    love.audio.newSource("assets/eating4.ogg"),
  },
  explode = love.audio.newSource("assets/explode.ogg"),
  meow = {
    love.audio.newSource("assets/meow1.ogg"),
    love.audio.newSource("assets/meow2.ogg"),
    love.audio.newSource("assets/meow3.ogg"),
    love.audio.newSource("assets/meow4.ogg"),
    love.audio.newSource("assets/meow5.ogg"),
  },
  murder = love.audio.newSource("assets/murder.ogg"),
  purr = love.audio.newSource("assets/purr.ogg"),
}

s.music:setLooping(true)

return function(toplay)
  if s[toplay] then
    if type(s[toplay]) == "table" then
      local index = math.random(#s[toplay])
      s[toplay][index]:stop()
      s[toplay][index]:play()
    else
      s[toplay]:stop()
      s[toplay]:play()
    end
  else
    print("TODO: Add sfx `"..toplay.."`")
  end
end

