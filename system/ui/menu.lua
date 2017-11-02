local menu = system.ui.button:new({
	type = "menu"
})

menu.child.active = false

menu:addCallback("mousereleased","open",function(self)
	if self.child.is then
		self.child.active = self.over or self.child:is("over")
	else
		self.child.active = self.over
	end
end)

return menu