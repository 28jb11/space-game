extends Control

# TODO what is this doing here?
@onready var tile_wrapper: TileMapLayer = $"../TerrainTiles"

@onready var width_input = $WidthInput
@onready var height_input = $HeightInput
@onready var generate_terain_button = $GenerateTerrainButton
@onready var terrain_generator = $"../GenerateTerrain"
@onready var frequency_slider = $Frequency

@onready var terrain_id = 2

var tile_sources

var terrain_map : Dictionary

func _ready() -> void:
	# TODO what is this doing here?
	# This should only happen in main, or in a node dedicated to initialization.
	# How?
	tile_sources = tile_wrapper.initialize()

func _on_generate_terrain_button_pressed() -> void:
	print("generate terrain button pressed")
	generate_terrain()

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


func _on_frequency_drag_ended(_value_changed: bool) -> void:
	terrain_generator.set_frequency(frequency_slider.value)
	pass # Replace with function body.
