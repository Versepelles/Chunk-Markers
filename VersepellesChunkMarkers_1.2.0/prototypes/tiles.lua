local colors = {
	["red"] = {order = "a", map_color = {r = 0.5, g = 0.0, b = 0.0}, result = "red-hazard-concrete"},
	["orange"] = {order = "b", map_color = {r = 0.5, g = 0.15, b = 0.0}, result = "orange-hazard-concrete"},
	["yellow"] = {order = "c", map_color = {r = 0.5, g = 0.5, b = 0.0}, result = "yellow-hazard-concrete"},
	["green"] = {order = "d", map_color = {r = 0.0, g = 0.5, b = 0.0}, result = "green-hazard-concrete"},
	["blue"] = {order = "e", map_color = {r = 0.0, g = 0.0, b = 0.5}, result = "blue-hazard-concrete"},
	["purple"] = {order = "f", map_color = {r = 0.5, g = 0.0, b = 0.5}, result = "purple-hazard-concrete"},
}

for color, color_data in pairs(colors) do
	-- Item
	local item = util.table.deepcopy(data.raw["item"]["hazard-concrete"])
	item.name = color .. "-hazard-concrete"
	item.icon = "__VersepellesChunkMarkers__/graphics/icons/" .. color .. "-hazard-concrete.png"
	item.order = color_data.order
	item.subgroup = "color-hazard-concrete"
	item.place_as_tile.result = color .. "-hazard-concrete"
	--item.place_as_tile.condition_size = 1
	data:extend({item})
	
	-- Recipe
	data:extend(
	{
		{
			type = "recipe",
			name = color .. "-hazard-concrete",
			enabled = "true",
			ingredients = 
			{
				{"stone", 1},
			},
			result = color .. "-hazard-concrete",
			result_count = 10,
		}
	})
	
	-- Tile
	local tile = util.table.deepcopy(data.raw["tile"]["hazard-concrete-left"])
	tile.name = color .. "-hazard-concrete"
	tile.next_direction = color .. "-hazard-concrete"
	tile.variants.main[1].picture = "__VersepellesChunkMarkers__/graphics/tiles/" .. color .. "-hazard-concrete/" .. color .. "-hazard-concrete-left1.png"
	tile.variants.main[2].picture = "__VersepellesChunkMarkers__/graphics/tiles/" .. color .. "-hazard-concrete/" .. color .. "-hazard-concrete-left2.png"
	tile.variants.main[3].picture = "__VersepellesChunkMarkers__/graphics/tiles/" .. color .. "-hazard-concrete/" .. color .. "-hazard-concrete-left4.png"
	tile.variants.inner_corner.picture = "__VersepellesChunkMarkers__/graphics/tiles/" .. color .. "-hazard-concrete/" .. color .. "-hazard-concrete-left-inner-corner.png"
	tile.variants.outer_corner.picture = "__VersepellesChunkMarkers__/graphics/tiles/" .. color .. "-hazard-concrete/" .. color .. "-hazard-concrete-left-outer-corner.png"
	tile.variants.side.picture = "__VersepellesChunkMarkers__/graphics/tiles/" .. color .. "-hazard-concrete/" .. color .. "-hazard-concrete-left-side.png"
	tile.variants.u_transition.picture = "__VersepellesChunkMarkers__/graphics/tiles/" .. color .. "-hazard-concrete/" .. color .. "-hazard-concrete-left-u.png"
	tile.variants.o_transition.picture = "__VersepellesChunkMarkers__/graphics/tiles/" .. color .. "-hazard-concrete/" .. color .. "-hazard-concrete-left-o.png"
	tile.map_color = color_data.map_color
	tile.minable.result = color_data.result
	tile.walking_speed_modifier = 1.0
	data:extend({tile})
end