local grid = class:new({
	x = 0, y = 0,
	elements = {},
	base = color.black
})

function grid:__init()
	self.canvas = love.graphics.newCanvas()
	self.subCanvas = love.graphics.newCanvas()
end

function grid:setPixel(x,y,c,p)
	--set up
	if not self[x] then
		self[x] = {}
	end
	if not self[x][y] then
		self[x][y] = {}
	end
	if not p.level then
		self.elements[#self.elements + 1] = p
		p.level = #self.elements
	end
	--modify
	if self[x][y][p] then
		self[x][y][p].color = c
		self:render(x,y)
		return self[x][y][p]
	end
	--add
	local pix = {color = c, parent = p}
	self[x][y][p] = pix
	for i , pixel in ipairs(self[x][y]) do
		if p.parent.level < pixel.parent.level then
			table.insert( self[x][y] , i , pix )
			self:render(x,y)
			return pix
		end
	end
	self[x][y][#self[x][y] + 1] = pix
	self:render(x,y)
	return pix
end

function grid:render(x,y)
	love.graphics.setCanvas( self.canvas )

	love.graphics.setColor( self.base )
	love.graphics.rectangle("fill",x,y,1,1)

	for i , pixel in ipairs( self[x][y] ) do
		love.graphics.setColor( pixel.color )
		love.graphics.rectangle("fill",x,y,1,1)
	end

	love.graphics.setCanvas()
end

function grid:draw()
	love.graphics.setColor( color.white )
	love.graphics.draw( self.canvas )
end

return grid