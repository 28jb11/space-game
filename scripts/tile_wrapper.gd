extends Node2D

class_name TileWrapper
@onready var tilemap: TileMapLayer = $"../TileMapLayer"
@onready var tileset = tilemap.tile_set
@onready var tileset_source = tileset.get_source(0)

func _ready():
	pass

func initialize() -> Dictionary:

	var terrains : Array = []
	print("initializing terrain sets...")
	for i in range(tileset.get_custom_data_layers_count()):
		terrains.append(tileset.get_custom_data_layer_name(i))

	var marching_squares_tiles = get_marching_squares_tiles(terrains)
	print(marching_squares_tiles)
	return marching_squares_tiles
	

func get_tileset_custom_data(terrain : String) -> Dictionary:
	var tile_positions = []
	for i in range(tileset_source.get_tiles_count()):
		tile_positions.append(tileset_source.get_tile_id(i)) # tile positions in tileset

	var tileset_custom_data = {}
	for tile_position in tile_positions:
		var tile_data = tileset_source.get_tile_data(tile_position, 0)
		var custom_data = tile_data.get_custom_data(terrain)
		tileset_custom_data[tile_position] = custom_data
		
	return tileset_custom_data
	
func get_marching_squares_tiles(terrains : Array) -> Dictionary:
	var marching_squares_tiles : Dictionary = {}
	for terrain in terrains:
		var custom_data = get_tileset_custom_data(terrain)
		var valid_tiles: Dictionary = {}
		for key in custom_data.keys():
			if custom_data[key] != -1:
				valid_tiles[key] = custom_data[key]
		marching_squares_tiles[terrain] = valid_tiles
	return marching_squares_tiles

func tileset_test(cases: Dictionary, cell_position : Vector2):
	for atlas_position in cases.keys():
		# tilemap.set_cell(0, cell_position, tileset.get_source_id(0), atlas_position, 0)
		tilemap.set_cell(cell_position, 0, atlas_position, 0)
		cell_position += Vector2(1,0)

func apply_marching_squares(map: Dictionary, cases: Dictionary, grid_width: int, grid_height: int):
	print("applying marching squares tiles...")
	
	for custom_data_layer in cases.keys():
		for x in range(grid_width - 1):
			for y in range(grid_height - 1):

				var top_left = map.get(Vector2(x, y), "")
				var top_right = map.get(Vector2(x + 1, y), "")
				var bottom_left = map.get(Vector2(x, y + 1), "")
				var bottom_right = map.get(Vector2(x + 1, y + 1), "")
				
				var index = 0
				if bottom_left:
					index |= 1
				if bottom_right:
					index |= 2
				if top_right:
					index |= 4
				if top_left:
					index |= 8

				# Assuming 'cases' dictionary has structure {custom_data_layer_name: {tile_atlas_position: marching_squares_case_value}}
				var tiles_for_layer = cases[custom_data_layer]
				for tile_position in tiles_for_layer.keys():
					var case_value = tiles_for_layer[tile_position]
					if case_value == index:
						# Apply the tile_id to the tilemap at the correct position
						# tilemap.set_cell(0, Vector2i(x, y), tileset.get_source_id(0), tile_position, 0)
						tilemap.set_cell(Vector2i(x,y), tileset.get_source_id(0), tile_position, 0)
						break
