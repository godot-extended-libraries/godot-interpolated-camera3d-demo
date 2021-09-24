# Copyright © 2020 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.
extends VBoxContainer

@onready var interpolated_camera := $"../InterpolatedCamera3D"
@onready var target_camera := $"../CharacterBody3D/Pivot/TargetCamera" as Camera3D


func _on_translate_speed_value_changed(value: float) -> void:
	interpolated_camera.translate_speed = value


func _on_rotate_speed_value_changed(value):
	interpolated_camera.rotate_speed = value


func _on_fov_value_changed(value: float) -> void:
	target_camera.fov = value


func _on_view_distance_value_changed(value: float) -> void:
	target_camera.far = value


func _on_max_fps_value_changed(value: float) -> void:
	Engine.target_fps = floor(value)
