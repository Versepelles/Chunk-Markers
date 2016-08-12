require("config")

local marker_names = {
	["red-rectangle-marker"] = {order = "a", subgroup = "rectangle-markers"},
	["orange-rectangle-marker"] = {order = "b", subgroup = "rectangle-markers"},
	["yellow-rectangle-marker"] = {order = "c", subgroup = "rectangle-markers"},
	["green-rectangle-marker"] = {order = "d", subgroup = "rectangle-markers"},
	["blue-rectangle-marker"] = {order = "e", subgroup = "rectangle-markers"},
	["purple-rectangle-marker"] = {order = "f", subgroup = "rectangle-markers"},
	
	["red-chunk-marker"] = {order = "a", subgroup = "chunk-markers"},
	["orange-chunk-marker"] = {order = "b", subgroup = "chunk-markers"},
	["yellow-chunk-marker"] = {order = "c", subgroup = "chunk-markers"},
	["green-chunk-marker"] = {order = "d", subgroup = "chunk-markers"},
	["blue-chunk-marker"] = {order = "e", subgroup = "chunk-markers"},
	["purple-chunk-marker"] = {order = "f", subgroup = "chunk-markers"},
	
	["rectangle-unmarker"] = {order = "a", subgroup = "unmarkers"},
	["chunk-unmarker"] = {order = "b", subgroup = "unmarkers"},
}

for marker, marker_data in pairs(marker_names) do
	-- Item
	data:extend(
	{
		{
			type = "item",
			name = marker,
			icon = Mod_Name .. "/graphics/icons/" .. marker .. ".png",
			flags = {"goes-to-quickbar"},
			subgroup = marker_data.subgroup,
			order = marker_data.order,
			place_result = marker,
			stack_size = 100,
		}
	})
	
	-- Recipe
	data:extend(
	{
		{
			type = "recipe",
			name = marker,
			enabled = "true",
			ingredients = 
			{
				{"stone", 1},
			},
			result = marker,
			result_count = 2,
		}
	})

	-- Entity
	local ent
	ent = util.table.deepcopy(data.raw["container"]["steel-chest"])
	ent.name = marker
	ent.minable.result = nil
	ent.icon = Mod_Name .. "/graphics/icons/" .. marker .. ".png"
	ent.picture =
		{
		  filename = Mod_Name .. "/graphics/entity/" .. marker .. "/" .. marker .. ".png",
		  priority = "extra-high",
		  width = 49,
		  height = 45,
		  shift = {0, 0}
		}
	ent.inventory_size = 0
	data:extend({ent})
end