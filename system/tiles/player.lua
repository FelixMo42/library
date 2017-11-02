local player = class:new({
	type = "player", name = "def",
	stats = {
		int = 0, wil = 0, chr = 0,
		str = 0, con = 0, dex = 0,
	},
	moves = {movement = 5, main = 1, sub = 2},
	actions = {
		move = system.tiles.actions.move:new(),
		endTurn = system.tiles.actions.endTurn:new()
	},
	x = 1, y = 1, gx = 1, gy = 1, px = 1, py = 1,
	MP = 20, HP = 20,
	queue = {}, ai = {},
	color = color.blue
})

--functions

function player:__init()
	self.gx, self.gy = self.x, self.y
	self.px, self.py = self.x, self.y
	for k , v in pairs(self.moves) do
		self.moves[k.."_max"] = v
	end
	for key , action in pairs(self.actions) do
		self:addAction( action )
	end
end

function player:draw(x, y, s)
	local x = x or (self.gx - self.map.x + 0.5) * system.tiles.setting.map.scale
	local y = y or (self.gy - self.map.y + 0.5) * system.tiles.setting.map.scale
	local s = s or system.tiles.setting.map.scale / 2
	love.graphics.setColor(self.color)
	love.graphics.circle("fill" , x , y , s , s )
end

function player:update(dt)
	if #self.queue == 0 then return true end
	if self.queue[1].type == "move" then
		self.px, self.py = self.px or self.gx, self.py or self.gy
		local d = 1 / math.sqrt( (self.queue[1].x - self.px) ^ 2 + (self.queue[1].y - self.py) ^ 2 )
	 	self.gx = self.gx + ( math.sign(self.queue[1].x - self.px) * dt * system.tiles.setting.player.speed * d )
		self.gy = self.gy + ( math.sign(self.queue[1].y - self.py) * dt * system.tiles.setting.player.speed * d )
		local cx = math.abs(self.gx - self.px) >= math.abs(self.queue[1].x - self.px)
		local cy = math.abs(self.gy - self.py) >= math.abs(self.queue[1].y - self.py)
		if cx and cy then
			self.gx, self.gy = self.queue[1].x, self.queue[1].y
			self.px, self.py = nil, nil
			table.remove(self.queue , 1)
			return self:update(dt)
		end
	else
		if not self.queue[1].func(self.actions[self.queue[1].type],self.queue[1].x,self.queue[1].y) then
			return self:update(dt)
		end
	end
	return false
end

function player:turn()
	for k in pairs(self.moves) do
		if not k:find("_max") then
			self.moves[k] = self.moves[k.."_max"]
		end
	end
	if self.ai.turn then
		self.ai.turn( self )
	end
end

function player:addAction(action)
	self.actions[action.name] = action
	action.player = self
end

function player:setPos(x,y)
	self.x , self.y = x , y
	self.map[x][y]:setPlayer( self )
end

system.tiles.players = {}

return player