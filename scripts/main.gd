extends Node

@onready var tile_wrapper = $TerrainTiles
@onready var test_controls: Control = $TestControls

var tile_sources

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_sources = tile_wrapper.initialize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ShowTestOverlay"):
		test_controls.visible = not test_controls.visible
	pass
