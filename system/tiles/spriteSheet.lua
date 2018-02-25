local spriteSheet = class:new({
	type = "spriteSheet",
	name = "sheet",
	size = 15, ids = 0,
	sprites = {}
})

function spriteSheet:__init()
	setmetatable(self.sprites , { __index = {} })

	if not self.img then
		if self.path then
			self.img = self.path
		else
			return
		end
	end
	
	if type(self.img) == "string" then self.path = self.img end
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	self.img = love.graphics.newImage(self.img)

	for id , sprite in pairs(self.sprites) do
		self:addSprite(sprite.name,sprite.x,sprite.y,sprite.w,sprite.h,sprite.sx,sprite.sy,sprite.id)
	end
end

function spriteSheet:creatSprite(name,x,y,w,h,sx,sy,id)
	return setmetatable( {
		name = name, type = "sprite", quad = quad, id = id,
		x = x, y = y, w = w, h = h, sx = sx, sy = sy,
		refactor = function(this)
			this.quad = love.graphics.newQuad(this.x * self.size,this.y * self.size,this.w * self.size,this.h * self.size , self.img:getDimensions() )
		end
	} , {
		__type = "sprite",
		__tostring = function(this)
			return "spriteSheet."..self.file..".sprites["..this.id.."]"
		end,
		__call = function(this,dx,dy,dw,dh)
			love.graphics.draw(self.img, this.quad, dx - this.sx * dh,dy - this.sy * dw, 0 , dw / self.size,dh / self.size)
		end
	} )
end

function spriteSheet:addSprite(name,x,y,w,h,sx,sy,id)
	sprite = self:creatSprite(name,x,y,w or 1,h or 1,sx or 0,sy or 0,id or self.ids)
	self.sprites[sprite.id] = sprite
	getmetatable(self.sprites).__index[sprite.name] = sprite
	getmetatable(self.sprites).__index[sprite] = sprite
	sprite:refactor()
	self.ids = math.max(sprite.id + 1,self.ids)
	return sprite
end

function spriteSheet:deletSprite(targ)
	for k , v in pairs(self.sprites) do
		if k == targ or v == targ then
			local sprite = self.sprites[k]
			self.sprites[k] = nil
			return sprite
		end
	end
end

system.tiles.spriteSheets = {}

return spriteSheet