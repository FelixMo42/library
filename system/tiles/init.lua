system.update.include("lua")

system.tiles.path = require "system/tiles/path"
system.tiles.setting = require "system/tiles/setting"
system.tiles.skill = require "system/tiles/skill"
system.tiles.action = require "system/tiles/action"
system.tiles.item = require "system/tiles/item"
system.tiles.object = require "system/tiles/object"
system.tiles.player = require "system/tiles/player"
system.tiles.tile = require "system/tiles/tile"
system.tiles.map = require "system/tiles/map"

system.tiles.globolize = function(t)
	tiles = system.tiles
	setting = tiles.setting
	map = tiles.map

	skill = tiles.skill
	ability = tiles.ability
	map = tiles.map
	player = tiles.player
	item = tiles.item
	object = tiles.object
	tile = tiles.tile

	skills = tiles.skills
	actions = tiles.actions
	maps = tiles.maps
	players = tiles.players
	items = tiles.items
	objects = tiles.objects
	tiles = tiles.tiles 
end