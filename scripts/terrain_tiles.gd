extends TileMapLayer

var tileset : TileSet



func initialize():
	# get tileset
	# tileset has multiple sources. each source is a different terrain set
	tileset = self.tile_set
	#test_tileset_sources(tileset)
	
	# create structure for each terrain source
	var tile_sources = []
	for source_id in range(tileset.get_source_count()):
		var ms = []
		for i in range(16):
			ms.append([])

		var atlas_size = tileset.get_source(source_id).get_atlas_grid_size()
		for x in range(atlas_size.x):
			for y in range(atlas_size.y):
				var ms_case = tileset.get_source(source_id).get_tile_data(Vector2i(x , y), 0).get_custom_data("ms_case")
				if ms_case < 16:
					ms[ms_case].append(Vector2i(x,y))
		tile_sources.append(ms)
		print(tile_sources)
		

func test_tileset_sources(tileset: TileSet):
	
	var y_offset = 0
	# for every tileset source in the tileset
	for source_id in range(tileset.get_source_count()):
		# initialize source to a variable
		var tileset_source = tileset.get_source(source_id)
		
		var atlas_size = tileset_source.get_atlas_grid_size()
		print(atlas_size)
	
		for x in range(atlas_size.x):
			for y in range(atlas_size.y):
				var tile_data = tileset_source.get_tile_data(Vector2i(x , y), 0)
				print(tile_data.get_custom_data("ms_case"))
				
				set_cell(Vector2i(x , y + y_offset), (source_id), Vector2i(x , y), 0)
				print(
				"setting cell at: ", x, " , ", (y + y_offset),
				" | source_id: ", source_id,
				" | atlas position: ", x, " , ", y)
		y_offset += atlas_size.y

func apply_marching_squares(map: Dictionary, cases: Dictionary):
	print(cases)
	print("applying marching squares tiles...")

	# for each terrain set?
	# this doesn't make too much sense.
	for custom_data_layer in cases.keys():
		# for each position in the map to be rendered
		# this makes perfect sense
		for position in map.keys():
			var x = position.x
			var y = position.y

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
			
			# maybe just return the index of requested tile?

			# Assuming 'cases' dictionary has structure
			# {custom_data_layer_name: {tile_atlas_position: marching_squares_case_value}}
			# var tiles_for_layer = cases[custom_data_layer]
			# for tile_position in tiles_for_layer.keys():
				# var case_value = tiles_for_layer[tile_position]
				# if case_value == index:
					# Apply the tile_id to the tilemap at the correct position
					# tilemap.set_cell(Vector2i(x, y), tileset.get_source_id(0), tile_position, 0)
					# break
