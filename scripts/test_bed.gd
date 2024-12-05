extends Node

@onready var width_input = $TestControls/WidthInput
@onready var height_input = $TestControls/HeightInput
@onready var generate_terain_button = $TestControls/GenerateTerrainButton
@onready var terrain_generator = $GenerateTerrain

@onready var tile_wrapper = $TerrainTiles

@onready var terrain_id = 0

var tile_sources

# var MS_tiles : Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# MS_tiles = tile_wrapper.initialize()
	tile_sources = tile_wrapper.initialize()
	print(tile_sources)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_generate_terrain_button_pressed() -> void:
	var terrain_map = terrain_generator.generate_terrain_grid(int(width_input.text), int(height_input.text))
	tile_wrapper.apply_tiles(terrain_map, terrain_id, tile_sources[terrain_id])
	print(terrain_map)

func _on_select_terrain_menu_item_selected(index: int) -> void:
	terrain_id = index
