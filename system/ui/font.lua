local font = setmetatable( {} , {
	__index = function(self,key)
		if type(key) == "number" then
			self[key] = love.graphics.newFont(key)
			return self[key]
		end
	end
} )

font.default = love.graphics.getFont()

return font