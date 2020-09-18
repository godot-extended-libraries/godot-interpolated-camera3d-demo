# Copyright © 2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
extends KinematicBody3D

# Required to rotate around the cube.
@onready var pivot := $Pivot as Node3D

var ROT_SPEED = 0.002
var velocity := Vector3()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		var rot_x := pivot.rotation.x - mm.relative.y * ROT_SPEED
		rot_x = clamp(rot_x, -0.25 * TAU, 0.25 * TAU)
		var rot_y := pivot.rotation.y - mm.relative.x * ROT_SPEED
		pivot.transform.basis = Basis(Vector3(rot_x, rot_y, 0))

	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta: float) -> void:
	# Apply friction and gravity.
	velocity *= 0.96
	velocity.y -= 0.5

	var motion := Vector3()
	motion.x += Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.z += Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	motion = motion.rotated(Vector3(0, 1, 0), pivot.rotation.y)
	velocity = move_and_slide(velocity + motion)
