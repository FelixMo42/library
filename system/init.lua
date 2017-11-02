require "system/setup"

class = require "system/class"

system.settings = setmetatable( {} , { __index = function(self,key) self[key] = {}; return self[key] end } )
if love.conf then love.conf(system.settings) end

if system.settings.update.default or system.settings.update.default == nil then
	system.update.include("lua")
	
	system.update.globalize("filesystem")
	system.update.globalize("settings")

	system.update.include("ui")
	system.update.globalize("ui")
	button = ui.button
	color = ui.color
	font = ui.font

	system.update.include("tabs")
	system.update.globalize("tabs")
	system.update.globalize("screen")
	system.update.globalize("mouse")
end

for i , lib in pairs(system.settings.update.includes or {}) do
	system.update.include(lib)
end

if system.filesystem:exist("setup.lua") then
	require "setup"
end

for k , v in pairs( system.load ) do
	v(k,v)
end