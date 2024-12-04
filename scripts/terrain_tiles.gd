extends TileMapLayer

var tileset : TileSet

func initialize():
	tileset = self.tile_set
	for i in range(tileset.get_source_count()):
		print(tileset.get_source(i))


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
