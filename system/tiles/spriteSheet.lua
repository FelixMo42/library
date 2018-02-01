local spriteSheet = class:new({
	path = "data/grid.png",
	size = 15,
	sprites = {}
})

function spriteSheet:__init()
	self.img = love.graphics.newImage(self.path)
end

function spriteSheet:addSprite(name,x,y,w,h,sx,sy)
	w , h , sx , sy = w or 1, h or 1 , sx or 0 , sy or 0
	local quad = love.graphics.newQuad( x * self.size,y * self.size,w * self.size,h * self.size , self.img:getDimensions() )
	local width = self.size
	local height = self.size
	self.sprites[name] = function(dx,dy,dw,dh)
		local s = x + y + w + h --save them for upvales
		love.graphics.draw(self.img, quad, dx - sx * w,dy - sy * h, 0 , dw / width , dh / height)
	end
	return self.sprites[name]
end

function spriteSheet:deletSprite(targ)
	for k , v in pairs(self.sprites) do
		if k == targ or v == targ then
			local sprite = self.sprites[name]
			self.sprites[name] = nil
			return name
		end
	end
end

system.tiles.spriteSheets = {}

return spriteSheet