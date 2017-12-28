local object = class:new({
	type = "object", name = "def",
	color = color.brown,
	walkable = false, moveCost = 1,
	width = 1, height = 1
})

--functions

function object:__tostring()
	local s = "system.tiles."
	if self.file then
		s = s.."objects."..self.file..":new({"
	else
		s = s.."object:new({"
	end
	return s.."})"
end

function object:draw(x,y,s)
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill",x - s * (self.width - 1),y - s * (self.height - 1),s * self.width,s * self.height)
end

--load

system.tiles.objects = {}

return object