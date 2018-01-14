local grid = class:new({
	type = "grid",
	x = 0, y = 0,
	width = 0, height = 0,
	elements = {},
	base = color.black,
	minX = 0, maxX = 0,
	minY = 0, maxY = 0,
	physical = false
})

function grid:__init()
	self.canvas = love.graphics.newCanvas()
	self.subCanvas = love.graphics.newCanvas()
end

function grid:dofunc(f,...)
	local inpt = {...}
	local x, y = inpt[1], inpt[2]
	if type(x) == "number" and type(y) == "number" then
		if self[x] and self[x][y] then
			for i = #self[x][y], 1 , -1 do
				if self[x][y][i].dofunc then
					self[x][y][i]:dofunc(f,...)
				elseif self[x][y][i][f] then
					self[x][y][i][f](...)
				end
			end
		end
	elseif self[f] then
		self[f](self)
	end
end

function grid:setPixel(x,y,p,d)
	--set up
	if not self[x] then
		self[x] = {}
		if x > self.maxX then
			self.maxX = x
		end
		if x < self.minX then
			self.minX = x
		end
	end
	if not self[x][y] then
		self[x][y] = {}
		if y > self.maxY then
			self.maxY = y
		end
		if y < self.minY then
			self.maxY = x
		end
	end
	if not p.level then
		self.elements[#self.elements + 1] = p
		p.level = #self.elements
	end
	--set solid
	if p.solid then
		if type(d) == "boolean" then
			self:setSolid(x,y,p,d)
		else 
			self:setSolid(x,y,p)
		end
	end
	if p.visible then
		return self:setVisible(x,y,p,d)
	end
end

function grid:setSolid(x,y,p,s)
	local s = s or p.solid
	--set solid
	if self[x][y][p] then
		local pix = self[x][y][p]
		if pix.solid == s then
			return
		else
			self[x][y][p].solid = s
		end
	else
		local pix = {solid = s, parent = p}
		self[x][y][p] = pix
		for i , pixel in ipairs(self[x][y]) do
			if p.parent.level < pixel.parent.level then
				table.insert( self[x][y] , i , pix )
			end
		end
		self[x][y][#self[x][y] + 1] = pix
	end
	--set pixel
	self[x][y][0] = false
	for i = 1, #self[x][y] do
		if self[x][y][i] then
			self[x][y][0] = true
			return
		end
	end
end

function grid:setVisible(x,y,p,c)
	local c = c or p.color
	--modify
	if self[x][y][p] then
		local pix = self[x][y][p]
		if pix[1] ~= c[1] or pix[2] ~= c[2] or pix[3] ~= c[3] or pix[4] ~= c[4] then
			self[x][y][p].color = c
			self:render(x,y)
		end
		return pix
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
	love.graphics.rectangle("line",self.minX,self.minY , self.maxX, self.maxY)
	love.graphics.draw( self.canvas )
end

function grid:getRoof(x,y,w,h,m)
	local max = math.max(y + m , self.minY)
	for y = math.floor(y), math.ceil(max), -1 do
		for x = math.ceil(x), math.floor(x + w - 1) do
			if self[x] and self[x][y] and self[x][y][0] then
				return y + 1
			end
		end
	end
	return max
end

function grid:getFloor(x,y,w,h,m)
	local max = math.min(y + h + m , self.maxY)
	for y = math.ceil(y + h), math.ceil(max) do
		for x = math.ceil(x), math.floor(x + w - 1) do
			if self[x] and self[x][y] and self[x][y][0] then
				return y
			end
		end
	end
	return max
end

function grid:getRightWall(x,y,w,h,m)
	local max = math.min(x + w + m , self.maxX)
	for x = math.floor(x + w), math.ceil(max) do
		for y = math.ceil(y), math.floor(y + h - 1) do
			if self[x] and self[x][y] and self[x][y][0] then
				return x
			end
		end
	end
	return max
end

function grid:getLeftWall(x,y,w,h,m)
	local max = math.max(x + m , self.minY)
	for x = math.floor(x + x), math.ceil(max), -1 do
		for y = math.ceil(y), math.floor(y + h - 1) do
			if self[x] and self[x][y] and self[x][y][0] then
				return x + 1
			end
		end
	end
	return max
end

return grid