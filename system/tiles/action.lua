local action = class:new({
	type = "ability", name = "def",
	moveType = "main", moves = 1,
	cost = 0
})

function action:__call(x,y,...)
	if not self.player then return false end
	if not system.tiles.path:open(self.player.map,x,y,{h = 2}) then return false end
	if not self:cheak(x,y,...) then return false end
	self.player.queue[#self.player.queue + 1] = {x = x, y = y, type = self.id, func = self.graphics}
	if self.func then return self:func(x,y,...) or true end
	return true
end

function action:cheak()
	if self.player.moves[self.moveType] < self.moves then return false end
	self.player.moves[self.moveType] = self.player.moves[self.moveType] - self.moves
	return true
end

system.tiles.actions = {}

system.tiles.actions.move = action:new({
	id = "move", name = "move",
	moveType = "movement",
	func = function(self,x,y)
		self.player:setPos(x,y)
	end
})

system.tiles.actions.endTurn = action:new({
	id = "endTurn", name = "end turn",
	moves = 0,
	func = function(self)
		for k in pairs(self.player.moves) do
			if not k:find("_max") then
				self.moves[k] = self.moves[k.."_max"]
			end
		end
	end
})

return action