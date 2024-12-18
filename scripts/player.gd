extends CharacterBody2D

# Speed of the spaceship
@export var speed = 200.0

# Reference to the Sprite2D and AnimationPlayer nodes
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

var is_turning = false
var current_animation = ""

# Method to change the spaceship's appearance
func change_spaceship_appearance(starting_frame: Vector2):
	var frame_size = sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)
	sprite.region_rect = Rect2(starting_frame, frame_size)

func _process(delta):
	velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		if current_animation != "turn_right":
			animation_player.play("turn_right")
			current_animation = "turn_right"
			is_turning = true
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		if current_animation != "turn_left":
			animation_player.play("turn_left")
			current_animation = "turn_left"
			is_turning = true
	else:
		# Only play idle if currently not turning
		if current_animation != "idle":
			animation_player.play("idle")
			current_animation = "idle"
			is_turning = false

	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed

	move_and_slide()

# This function will be called when the animation finishes
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "turn_left" or anim_name == "turn_right":
		# Stop on the last frame of the turning animation
		animation_player.stop()
		animation_player.seek(animation_player.current_animation_length, true)
		is_turning = false
		current_animation = "idle"
