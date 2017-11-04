local tile = class:new({
	type = "tile", name = "def",
	walkable = true,
	color = {0,255,0},
	moveCost = 1,
	x = 0, y = 0
})

--functions

function tile:draw(x,y,s)
	--tile
	local s = s or system.tiles.setting.map.scale
	local x = x or (self.x - self.map.x) * system.tiles.setting.map.scale
	local y = y or (self.y - self.map.y) * system.tiles.setting.map.scale
	love.graphics.setColor(color.green)
	love.graphics.rectangle("fill",x,y,s,s)
	if system.tiles.setting.map.line then
		love.graphics.setColor(color.black)
		love.graphics.rectangle("line",x,y,s,s)
	end
	--object
	if self.object then
		self.object:draw(x,y,s)
	end
	--item
	if self.item then
		self.item:draw(x,y,s)
	end
end

function tile:setPlayer(player)
	self.player = player
	player.tile.player = nil
	player.tile = self
end

--load

system.tiles.tiles = {}

return tile