local action = class:new({
	type = "ability", name = "def",
	moveType = "main", moves = 1,
	range = 1, height = 2,
	cost = 0,
})

--functions

function action:__call(x,y,...)
	--cheak if possible
	if not self.player then return false end
	if not self:cheak(x,y,...) then return false end
	--do it
	self.player:useEnergy(self.moveType, self.moves)
	if self.drawFunc then
		self.player.queue:add(self, x,y)
	end
	if self.func then return self:func(x,y,...) or true end
	return true
end

function action:cheak(x,y,...)
	if not system.tiles.path:line(self.player.map , self.player.x,self.player.y , x,y , self) then return false end
	if self.player.moves[self.moveType] < self.moves then return false end
	return true
end

--load

system.tiles.actions = {}

system.tiles.actions.move = action:new({
	id = "move", name = "move",
	moveType = "movement",
	height = 0,
	func = function(self,x,y)
		self.player:setPos(x,y)
	end,
	drawFunc = function(self,x,y,dt)
		local self = self.player
		self.px, self.py = self.px or self.gx, self.py or self.gy
		local d = 1 / math.sqrt( (x - self.px) ^ 2 + (y - self.py) ^ 2 )
	 	self.gx = self.gx + ( math.sign(x - self.px) * dt * system.tiles.setting.player.speed * d )
		self.gy = self.gy + ( math.sign(y - self.py) * dt * system.tiles.setting.player.speed * d )
		local cx = math.abs(self.gx - self.px) >= math.abs(x - self.px)
		local cy = math.abs(self.gy - self.py) >= math.abs(y - self.py)
		if cx and cy then
			self.gx, self.gy = x, y
			self.px, self.py = nil, nil
			return false
		end
		return true
	end
})

system.tiles.actions.endTurn = action:new({
	id = "endTurn", name = "end turn",
	moves = 0,
	func = function(self)
		self.player.map:nextTurn()
	end,
	cheak = function(self,x,y)
		return true
	end
})

return action