local font = setmetatable( {} , {
	__index = function(self,key)
		if type(key) == "number" then
			self[key] = love.graphics.newFont(self.font, key)
			return self[key]
		end
	end
} )

font.font = "system/ui/Verdana.ttf"

font.default = font[love.graphics.getFont():getHeight()]

love.graphics.setFont( font.default )

return font