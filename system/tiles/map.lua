local map = class:new({
	type = "map", name = "def",
	players = {}, playerMap = {},
	width = 100, height = 100,
	turn = 1, position = 0,
	x = 1, y = 1
})

--functions

function map:__init()
	for x = 1 , self.width do
		self[x] = self[x] or {}
		self.playerMap[x] = self.playerMap[x] or {}
		for y = 1 , self.height do
			self[x][y] = self[x][y] or (self.default or system.tiles.tile):new()
			self[x][y].map = self
			self[x][y].x = x
			self[x][y].y = y
		end
	end
	if #self.players > 0 then
		self:nextTurn()
	end
end

function map:draw()
	local b = 0
	local sx = math.max( math.floor( self.x ) - b , 1)
	local ex = math.min( math.floor( self.x + screen.width / system.tiles.setting.map.scale ) + b , self.width )
	local sy = math.max( math.floor( self.y ) - b , 1 ) 
	local ey = math.min( math.floor( self.y + screen.height / system.tiles.setting.map.scale ) + b , self.height )
	--tiles
	for y = sy , ey do
		for x = sx , ex do
			self[x][y]:draw()
		end
	end
	--players
	for y = sy , ey do
		for x = sx , ex do
			if self.playerMap[x][y] then
				self.playerMap[x][y]:draw()
			end
		end
	end
end

function map:update(dt)
	for i, player in pairs(self.players) do
		player:update(dt)
	end
end

function map:addPlayer(p, x, y)
	p.x = x or p.x
	p.y = y or p.y
	if self.playerMap[p.x][p.y] then return false , self.playerMap[p.x][p.y] , p end
	p.map = self
	self.players[#self.players + 1] = p
	p.tile = self[p.x][p.y]
	self[p.x][p.y]:setPlayer(p)
	return true , p , p
end

function map:nextTurn()
	self.position = self.position + 1
	if self.position > #self.players then
		self.turn = self.turn + 1
		self.position = 1
	end
	self.player = self.players[self.position]
	self.player:turn()
end

function map:setPos(x,y)
	if x then
		if setting.map.clamp then
			self.x = math.clamp(x , 1 , self.width - screen.width / setting.map.scale + 1)
		else
			self.x = x
		end
	end
	if y then
		if setting.map.clamp then
			self.y = math.clamp(y , 1 , self.height - screen.height / setting.map.scale + 1)
		else
			self.y = y
		end
	end
end

system.tiles.maps = {}

return map