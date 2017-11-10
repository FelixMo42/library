system.update.include("lua")

require "system/tiles/setting"

system.tiles.path = require "system/tiles/path"
system.tiles.skill = require "system/tiles/skill"
system.tiles.action = require "system/tiles/action"
system.tiles.item = require "system/tiles/item"
system.tiles.object = require "system/tiles/object"
system.tiles.player = require "system/tiles/player"
system.tiles.tile = require "system/tiles/tile"
system.tiles.map = require "system/tiles/map"

system.tiles.globolize = function(t)
	settings = system.settings

	path = system.tiles.path

	skill = system.tiles.skill
	ability = system.tiles.ability
	map = system.tiles.map
	player = system.tiles.player
	item = system.tiles.item
	object = system.tiles.object
	tile = system.tiles.tile

	skills = system.tiles.skills
	actions = system.tiles.actions
	maps = system.tiles.maps
	players = system.tiles.players
	items = system.tiles.items
	objects = system.tiles.objects
	tiles = system.tiles.tiles
end