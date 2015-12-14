local s = {

}

return function(toplay)
  if s[toplay] then
    s[toplay]:stop()
    s[toplay]:play()
  else
    print("TODO: Add sfx `"..toplay.."`")
  end
end
