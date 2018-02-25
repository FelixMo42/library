local textbox = system.ui.button:new({
	type = "textbox",
	active = false,
	b_over = 0,
	textColor_empty = system.ui.color.grey,
	stext = love.graphics.newText( love.graphics.getFont() ),
	cursor = "|", cursor_pos = 0, timer = 1,
	text = "",
	modes = {
		"active",
		"empty",
		"pressed",
		"over"
	}
})

textbox:addCallback("mousereleased","active",function(self)
	self.active = self.over
	self.timer = 0
end)

textbox:addCallback("update","timer",function(self,dt)
	self.timer = self.timer + dt
end)

textbox:addCallback("textinput","textinput",function(self,key,s)
	if not s then
		if not self.active then return end
		if love.keyboard.isDown("rgui","lgui") then return end
	end
	if not self.filter or self.filter:find(key) then
		self.timer = 0
		self.text = string.sub(self.text, 1, math.max(self.cursor_pos , 0))..key..string.sub(self.text, self.cursor_pos+1)
		self.cursor_pos = self.cursor_pos+1
		if self.onEdit then self:onEdit(key) end
	end
end)

textbox:addCallback("keypressed","cursor",function(self,key)
	if not self.active then return end
	self.timer = 0
	if key == "left" then
		self.cursor_pos = math.max(0, self.cursor_pos-1)
	elseif key == "right" then
		self.cursor_pos = math.min(self.text:len(), self.cursor_pos+1)
	end
end)

textbox:addCallback("keyreleased","key actions",function(self,key)
	if not self.active then return end
	if self.cursor_pos > 0 and key == "backspace" then
		self.timer = 0
		self.text = string.sub(self.text, 1, math.max(self.cursor_pos - 1 , 0))..string.sub(self.text, self.cursor_pos+1)
		self.cursor_pos = math.max(0, self.cursor_pos-1)
		if self.onEdit then self:onEdit(key) end
	elseif key == "return" then
		love.errhand("hi")
		self:dofunc("enter")
	elseif love.keyboard.isDown("rgui","lgui") then
		if key == "v" then
			local text = love.system.getClipboardText()
			for i = 1 , #text do
				self:dofunc("textinput",text:sub(i,i),true)
			end
		end
	end
end)

textbox:addCallback("keyreleased","empty",function(self,key)
	if not self.active then return end
	if #self.text == 0 then 
		self.empty = true
	else
		self.empty = false
	end
end)

textbox.draw.text = function(self)
	local stext = (self.startText or "")
	local etext = (self.endText or "")
	if self.empty then
		text = self.defText or ""
	else
		text = self.text
	end
	love.graphics.setColor(self.textColor)

	local l = #( ( {love.graphics.getFont():getWrap(text,self.width)} )[2] )
	local y = self.y + self.height / 2 -  (l * love.graphics.getFont():getHeight())/2
	love.graphics.printf(text,self.x,y,self.width,self.textMode or "center")

	if self.active and self.timer % 3 < 1.5 then
		self.stext:setFont( love.graphics.getFont() )
		self.stext:setf( {
			{255,255,000,000} , "|"..string.sub( self.text, 1 , math.max(self.cursor_pos - 1 , 0)),
			{255,255,255,255} , self.cursor,
			{255,255,000,000} , string.sub( self.text, self.cursor_pos + 1),
		}, self.width , self.textMode or "center", self.x,y )
		love.graphics.draw( self.stext )
	end
end

return textbox