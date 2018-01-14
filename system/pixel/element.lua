local element = class:new({
	type = "element",
	x = 0, y = 0, pixs = {},
	func = function() end,
	visible = true
})

function element:__init()
	self.canvas = love.graphics.newCanvas()
	if self.grid then
		self:render()
	end
end

function element:render()
	love.graphics.setCanvas( self.canvas )
	love.graphics.clear()
	self:func()
	local imgData = self.canvas:newImageData()
	love.graphics.setCanvas()
	for x = 0, imgData:getWidth() - 1 do
		for y = 0, imgData:getHeight() - 1 do
			local r, g, b, a = imgData:getPixel(x, y)
			if not self[x] then self[x] = {} end
			if a == 0 then
				if self[x] and self[x][y] and self[x][y].color[4] ~= 0 then
					self[x][y] = self.grid:setPixel(x,y,self,{r, g, b, a})
				end
			else
				self[x][y] = self.grid:setPixel(x,y,self,{r, g, b, a})
			end
		end
	end
end

function element:mousereleased(x,y)
	if self.func then
		self:func(x,y)
	end
end

return element