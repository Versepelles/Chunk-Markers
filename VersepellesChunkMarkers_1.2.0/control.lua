require("config")

---------------------------------------------------------
-- Constants
local CHUNK_SIZE = 32
local marker_materials = {
	["red-hazard-concrete"] = true,
	["orange-hazard-concrete"] = true,
	["yellow-hazard-concrete"] = true,
	["green-hazard-concrete"] = true,
	["blue-hazard-concrete"] = true,
	["purple-hazard-concrete"] = true,
}
local rectangle_markers = {
	["red-rectangle-marker"] = {material = "red-hazard-concrete"},
	["orange-rectangle-marker"] = {material = "orange-hazard-concrete"},
	["yellow-rectangle-marker"] = {material = "yellow-hazard-concrete"},
	["green-rectangle-marker"] = {material = "green-hazard-concrete"},
	["blue-rectangle-marker"] = {material = "blue-hazard-concrete"},
	["purple-rectangle-marker"] = {material = "purple-hazard-concrete"},
}
local chunk_markers = {
	["red-chunk-marker"] = {material = "red-hazard-concrete"},
	["orange-chunk-marker"] = {material = "orange-hazard-concrete"},
	["yellow-chunk-marker"] = {material = "yellow-hazard-concrete"},
	["green-chunk-marker"] = {material = "green-hazard-concrete"},
	["blue-chunk-marker"] = {material = "blue-hazard-concrete"},
	["purple-chunk-marker"] = {material = "purple-hazard-concrete"},
}

---------------------------------------------------------
-- Keep track of built objects
function builtEntity(event)
	global.first_markers = global.first_markers or {}
	local ent = event.created_entity
	local name = ent.name
	local first_marker = global.first_markers[name]
	
	if rectangle_markers[name] then
		if first_marker and first_marker.valid then
			markRectangle(ent.surface, first_marker.position, ent.position, rectangle_markers[name].material, rectangle_fill_mode)
			first_marker.destroy()
			global.first_markers[name] = nil
			ent.destroy()
		else
			global.first_markers[name] = ent
		end
	elseif name == "rectangle-unmarker" then
		if first_marker and first_marker.valid then
			unmarkRectangle(ent.surface, first_marker.position, ent.position, rectangle_fill_mode)
			first_marker.destroy()
			global.first_markers[name] = nil
			ent.destroy()
		else
			global.first_markers[name] = ent
		end
	elseif chunk_markers[name] then
		local chunk_pos1 = getChunkFromPosition(ent.position)
		local chunk_pos2 = {x = chunk_pos1.x + CHUNK_SIZE - 1, y = chunk_pos1.y + CHUNK_SIZE - 1}
		markRectangle(ent.surface, chunk_pos1, chunk_pos2, chunk_markers[name].material, chunk_fill_mode)
		ent.destroy()
	elseif name == "chunk-unmarker" then
		local chunk_pos1 = getChunkFromPosition(ent.position)
		local chunk_pos2 = {x = chunk_pos1.x + CHUNK_SIZE - 1, y = chunk_pos1.y + CHUNK_SIZE - 1}
		unmarkRectangle(ent.surface, chunk_pos1, chunk_pos2, chunk_fill_mode)
		ent.destroy()
	end
end
script.on_event(defines.events.on_built_entity, builtEntity)
script.on_event(defines.events.on_robot_built_entity, builtEntity)

---------------------------------------------------------
-- Return a table of border positions of a rectangle given two corners
function getRectanglePositions(pos1, pos2, fill_mode)
	local width = math.abs(pos2.x - pos1.x)
	local height = math.abs(pos2.y - pos1.y)
	local x = math.min(pos1.x, pos2.x)
	local y = math.min(pos1.y, pos2.y)
	local positions = {}
	
	-- Full Rectangle
	if fill_mode then
		for i = 0, width do
			for j = 0, height do
				table.insert(positions, {x = x + i, y = y + j})
			end
		end
	-- Boundary Rectangle
	else
		-- North/south edges
		for i = 0, width do
			table.insert(positions, {x = x + i, y = y})
			table.insert(positions, {x = x + i, y = y + height})
		end
		
		-- West/east edges
		for i = 0, height do
			table.insert(positions, {x = x, y = y + i})
			table.insert(positions, {x = x + width, y = y + i})
		end
	end
	return positions
end

---------------------------------------------------------
-- Create a border around a given rectangle
function markRectangle(surface, pos1, pos2, material, fill_mode)
	local rectangle_positions = getRectanglePositions(pos1, pos2, fill_mode)
	
	local tiles = {}
	for __, pos in pairs(rectangle_positions) do
		local tile = surface.get_tile(pos.x, pos.y)
		if not isWater(tile) then
			table.insert(tiles, {name = material, position = pos})
		end
	end
	
	surface.set_tiles(tiles)
end

---------------------------------------------------------
-- Delete a border around a given rectangle
function unmarkRectangle(surface, pos1, pos2, fill_mode)
	local rectangle_positions = getRectanglePositions(pos1, pos2, fill_mode)
	
	local tiles = {}
	for __, pos in pairs(rectangle_positions) do
		local tile = surface.get_tile(pos.x, pos.y)
		if marker_materials[tile.name] then
			table.insert(tiles, {name = unmark_material, position = pos})
		end
	end
	
	surface.set_tiles(tiles)
end

---------------------------------------------------------
-- Return the chunk position from a tile position
-- Not sure if this is the actual chunk, but it should give nice 32x32 blocks
function getChunkFromPosition(position)
	return {x = math.floor(position.x / CHUNK_SIZE) * CHUNK_SIZE, y = math.floor(position.y / CHUNK_SIZE) * CHUNK_SIZE}
end

---------------------------------------------------------
-- Returns whether the tile is a water tile
function isWater(tile)
	local name = tile.name
	return name == "water" or name == "water-green" or name == "deepwater" or name == "deepwater-green"
end

---------------------------------------------------------
-- Utility function to print to all players
function pall(str)
	if game and game.players then
		for __, player in pairs(game.players) do
			player.print(str)
		end
	end
end