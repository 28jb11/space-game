extends TileMapLayer

const ALTERNATIVE_TILE = 0

# tileset has multiple sources. each source is a different terrain set
@onready var tileset = self.tile_set

# creates data structures to find marching squares case values
func initialize() -> Array:
	
	if tileset == null:
		print("error initializing tileset")
	
	# create structure for each terrain source's ms_case data
	var tile_sources = []
	for source_id in range(tileset.get_source_count()):
		var ms = []
		for i in range(16):
			ms.append([])

		var atlas_size = tileset.get_source(source_id).get_atlas_grid_size()
		for x in range(atlas_size.x):
			for y in range(atlas_size.y):
				#print(tileset.get_source(source_id).get_tile_data(Vector2i(x,y), 0))
				var ms_case = null
				if tileset.get_source(source_id).get_tile_data(Vector2i(x,y), 0) != null:
					ms_case = tileset.get_source(source_id).get_tile_data(Vector2i(x , y), 0).get_custom_data("ms_case")
				#print(ms_case)
				if ms_case != null and ms_case < 16:
					ms[ms_case].append(Vector2i(x,y))
		tile_sources.append(ms)
	test_tileset_sources(tile_sources)
	return tile_sources

func test_tileset_sources(tile_sources):
	
	var x = 0
	var y = 0

	# for every tileset source in the tileset
	var source_id = 0
	for tile_source in tile_sources:
		y = 0
		for ms_case in tile_source:
			# TODO multiple tiles for 1 case detection
			set_cell(Vector2i(x , y), source_id, ms_case[0], 0)
			y += 1
		source_id += 1
		x += 1

func get_ms_index(map: Dictionary, grid_position: Vector2i) -> int:

		var x = grid_position.x
		var y = grid_position.y

		var top_left = map.get(Vector2(x, y), "")
		var top_right = map.get(Vector2(x + 1, y), "")
		var bottom_left = map.get(Vector2(x, y + 1), "")
		var bottom_right = map.get(Vector2(x + 1, y + 1), "")
		
		var index = 0
		if int(bottom_left) == 1:
			index |= 1
		if int(bottom_right) == 1:
			index |= 2
		if int(top_right) == 1:
			index |= 4
		if int(top_left) == 1:
			index |= 8
		
		return index

func apply_tiles(map: Dictionary, terrain_id: int, tile_source):
		for key in map:
			var ms_index = get_ms_index(map, Vector2i(key.x, key.y))
			var valid_tiles = tile_source[ms_index]
			var rng = RandomNumberGenerator.new()
			var ms_case_tile = 0
			if valid_tiles.size() > 1:
				# generate cumulative weights list based on on probabilities
				var weights = []
				for tile in valid_tiles:
					var tile_probability = get_tile_probability(tile, terrain_id)
					weights.append(tile_probability)
				ms_case_tile = weighted_random_choice(weights, rng)
			set_cell_ms(Vector2i(key.x,key.y), valid_tiles[ms_case_tile], terrain_id)

func get_tile_probability(tile, terrain_id) -> float:
	return tileset.get_source(terrain_id).get_tile_data(tile, 0).probability

func set_cell_ms(grid_position: Vector2i, atlas_position: Vector2i, terrain_id: int):
	set_cell(grid_position, terrain_id, atlas_position, ALTERNATIVE_TILE)

func weighted_random_choice(weights, rng):
	var cumulative_weights = []
	var sum = 0.0
	for weight in weights:
		sum += weight
		cumulative_weights.append(sum)
		
	var random_value = rng.randf_range(0.0, sum)
	
	for i in range(cumulative_weights.size()):
		if random_value < cumulative_weights[i]:
			return i
	return 0 # Fallback in case of rounding errors
