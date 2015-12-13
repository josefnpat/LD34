local ilovetexpack = {}

ilovetexpack.json = require "json"

function ilovetexpack.render(file)
  local atlas_raw = love.filesystem.read(file..".json")
  local data = lib.json.decode(atlas_raw)

  local obj = {}
  obj._width = data.width
  assert(obj._width)
  obj.getWidth = function(self) return self._width end
  obj._height = data.height
  assert(obj._height)
  obj.getHeight = function(self) return self._height end
  obj._image = love.graphics.newImage(file..".png")
  assert(obj._image)
  obj.getImage = function(self) return self._image end

  obj._sprites = {}
  for sprite_name,sprite_data in pairs(data.sprites) do
    local sprite = {}
    sprite._x = sprite_data.x
    assert(sprite._x)
    sprite.getX = function(self) return self._x end
    sprite._y = sprite_data.y
    assert(sprite._y)
    sprite.getY = function(self) return self._y end
    sprite._width = sprite_data.width
    assert(sprite._width)
    sprite.getWidth = function(self) return self._width end
    sprite._height = sprite_data.height
    assert(sprite._height)
    sprite.getHeight = function(self) return self._height end
    sprite._realWidth = sprite_data.real_width
    assert(sprite._realWidth)
    sprite.getRealWidth = function(self) return self._realWidth end
    sprite._realHeight = sprite_data.real_height
    assert(sprite._realHeight)
    sprite.getRealHeight = function(self) return self._realHeight end
    sprite._xOffset = sprite_data.xoffset
    assert(sprite._xOffset)
    sprite.getXOffset = function(self) return sprite_data._xOffset end
    sprite._yOffset = sprite_data.yoffset
    assert(sprite._yOffset)
    sprite.getYOffset = function(self) return sprite-data._yOffset end

    sprite._quad = love.graphics.newQuad(sprite_data.x,sprite_data.y,
      sprite_data.width,sprite_data.height,data.width,data.height)
    sprite.getQuad = function(self) return self._quad end

    sprite._image = obj._image
    sprite.draw = function(self,x,y,r,sx,sy,ox,oy,kx,ky)
      love.graphics.draw(self._image,self._quad,x,y,r,sx,sy,ox,oy,kx,ky)
    end
    sprite.drawFull = function(self,x,y,r,sx,sy,ox,oy,kx,ky)
      love.graphics.draw(self._image,self._quad,
        (x+self._xOffset)*sx,
        (y+self._yOffset)*sy,
        r,sx,sy,ox,oy,kx,ky)
    end

    assert(not obj._sprites[sprite_name])
    obj._sprites[sprite_name] = sprite
  end
  obj.getSprites = function(self) return self._sprites end

  return obj

end


return ilovetexpack
