extends Node

@onready var test_controls: Control = $TestControls

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("test_controls: ", test_controls)
	if test_controls:
		print("TestControls found successfully")
	else:
		print("TestControls not found")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ShowTestOverlay"):
		test_controls.visible = not test_controls.visible
	pass