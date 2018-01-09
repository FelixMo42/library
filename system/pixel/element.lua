local element = class:new({
	x = 0, y = 0, pixs = {},
	func = function() end
})

function element:__init()
	self.canvas = love.graphics.newCanvas()
	if self.grid then
		self:render()
	end
end

function element:render()
	love.graphics.setCanvas( self.canvas )
	self.func()
	local imgData = self.canvas:newImageData()
	love.graphics.clear()
	love.graphics.setCanvas()
	for x = 0, imgData:getWidth() - 1 do
		for y = 0, imgData:getHeight() - 1 do
			local r, g, b, a = imgData:getPixel(x, y)
			if not self[x] then self[x] = {} end
			if a == 0 then
				if self[x] and self[x][y] and self[x][y].color[4] ~= 0 then
					self[x][y] = self.grid:setPixel(x,y,{r, g, b, a},self)
				end
			else
				self[x][y] = self.grid:setPixel(x,y,{r, g, b, a},self)
			end
		end
	end
end

function element:savePixel(x,y,r, g, b, a)
	if not self[x] then
		self[x] = self[x] or {}
	end
	if self[x][y] then
		self[x][y].color = {r,g,b,a}
	else
		self[x][y] = self.grid:setPixel(x,y,{r,g,b,a},self)
	end
	self[x][y].show = a == 0
end

return element