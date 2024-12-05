extends Node

@onready var width_input = $TestControls/WidthInput
@onready var height_input = $TestControls/HeightInput
@onready var generate_terain_button = $TestControls/GenerateTerrainButton
@onready var terrain_generator = $GenerateTerrain

@onready var tile_wrapper = $TerrainTiles

@onready var terrain_id = 0

var tile_sources

var terrain_map : Dictionary

# var MS_tiles : Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# MS_tiles = tile_wrapper.initialize()
	tile_sources = tile_wrapper.initialize()
	print(tile_sources)
	terrain_map = terrain_generator.generate_terrain_grid(int(width_input.text), int(height_input.text))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_generate_terrain_button_pressed() -> void:
	generate_terrain()
	# print(terrain_map)
	
func generate_terrain():
	terrain_map = terrain_generator.generate_terrain_grid(int(width_input.text), int(height_input.text))
	tile_wrapper.apply_tiles(terrain_map, terrain_id, tile_sources[terrain_id])

func _on_select_terrain_menu_item_selected(index: int) -> void:
	terrain_id = index
	tile_wrapper.apply_tiles(terrain_map, terrain_id, tile_sources[terrain_id])

func _on_test_sources_pressed() -> void:
	tile_wrapper.test_tileset_sources(tile_sources)


func _on_clear_tiles_pressed() -> void:
	tile_wrapper.clear()

func _on_seed_text_submitted(new_text: String) -> void:
	terrain_generator.set_seed(int(new_text))
	generate_terrain()
