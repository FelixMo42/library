local player = class:new({
	type = "player", name = "def",
	stats = {
		int = 0, wil = 0, chr = 0,
		str = 0, con = 0, dex = 0,
	},
	moves = {movement = 5, main = 1, sub = 2},
	actions = {
		system.tiles.actions.move,
		system.tiles.actions.endTurn
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
		if type(key) == "number" then
			self:addAction( action:new() )
			self.actions[key] = nil
		end
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
	if not self.queue[1].func(self.queue[1].type,self.queue[1].x,self.queue[1].y,dt,self.queue[1]) then
		table.remove(self.queue , 1)
		return self:update(dt)
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
	self.actions[action.id] = action
	action.player = self
end

function player:setPos(x,y)
	self.x , self.y = x , y
	self.map[x][y]:setPlayer( self )
end

function player:useEnergy(type, amu)
	self.moves[type] = self.moves[type] - amu
	for move , value in pairs(self.moves) do
		if not move:find("_max") and value > 0 then
			return true
		end
	end
	self.map:nextTurn()
	return false
end

function player.queue:add(action,x,y,drawFunc)
	self[#self + 1] = {x = x, y = y, type = action, func = drawFunc or action.drawFunc}
end

--load

system.tiles.players = {}

return player