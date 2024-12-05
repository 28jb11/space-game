extends Node2D

class_name GenerateTerrain

@export var noise_height_text = NoiseTexture2D
var noise = Noise

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise = noise_height_text.noise

func generate_terrain_grid(grid_width : int, grid_height : int) -> Dictionary:
	var terrain0 = 0
	var terrain1 = 1
	
	var terrain_positions = {}
	
	for x in range(grid_width):
		for y in range(grid_height):
			var noise_val = noise.get_noise_2d(x, y)
			if noise_val <= 0.0:
				terrain_positions[Vector2(x, y)] = terrain0 
			elif noise_val > 0.0:
				terrain_positions[Vector2(x, y)] = terrain1 
	
	return terrain_positions

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_seed(seed: int):
	noise.seed = seed
