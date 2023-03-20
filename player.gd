# Copyright © 2020-present Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Required to rotate around the cube.
@onready var pivot := $Pivot as Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		const rot_speed = 0.002
		var rot_x := pivot.rotation.x - mm.relative.y * rot_speed
		rot_x = clamp(rot_x, -0.25 * TAU, 0.25 * TAU)
		var rot_y := pivot.rotation.y - mm.relative.x * rot_speed
		pivot.transform.basis = Basis.from_euler(Vector3(rot_x, rot_y, 0))

	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	# Apply friction.
	velocity.x *= 0.96
	velocity.y *= 0.98
	velocity.z *= 0.96

	if not is_on_floor():
		# Apply gravity.
		velocity.y -= gravity * delta

	# Player movement.
	var motion := Vector3()
	motion.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.z += Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	const move_speed = 1.5
	velocity += motion.rotated(Vector3(0, 1, 0), pivot.rotation.y) * move_speed
	move_and_slide()
