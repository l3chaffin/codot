extends Node3D


@onready var gun_pos =  get_node("../Head/GunPos")
@onready var cam = get_node("../Head/Camera3D")
@onready var head = get_node("../Head")
@onready var player = get_node("..")
var mouse_axis := Vector2()
var hold = false
var land_time = 0.0
var l_duration = 0.35
var walk_time = 0.0


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative


func _process(delta: float) -> void:
	land_time += delta / l_duration
	walk_time += delta * player.cur_speed * float(player.is_on_floor())
	
	global_position = gun_pos.global_position
	# Camera needs entire position set or it will fall behind on local Z axis
	cam.global_position = head.global_position
	
	if player.is_on_floor():
		# Animate landing after jump
		global_position.y = anim_landing(global_position.y, global_position.y - 0.65, land_time)
		cam.global_position.y = anim_landing(cam.global_position.y, cam.global_position.y - 0.5, land_time)
		if player.cur_speed > 0.0:
			rotation.z = sin(walk_time * 1.5) * 0.01
			global_position.y += sin(walk_time * 1.5) * -0.012
		else:
			rotation.z = lerp_angle(rotation.z, gun_pos.global_rotation.z, 10 * delta)
	else:
		land_time = 0.0
		rotation.z = lerp_angle(rotation.z, gun_pos.global_rotation.z, 10 * delta)
	
	# Clamped to prevent viewmodel from flipping on Z axis
	if gun_pos.global_rotation.x > deg_to_rad(-85) and gun_pos.global_rotation.x < deg_to_rad(85):
		rotation.x = clamp(rotation.x - mouse_axis.y * 0.47 * delta, deg_to_rad(-90), deg_to_rad(90))
	rotation.y = rotation.y - mouse_axis.x * 0.47 * delta
	# Lerp to final position
	rotation.x = lerp_angle(rotation.x, gun_pos.global_rotation.x, 7 * delta)
	rotation.y = lerp_angle(rotation.y, gun_pos.global_rotation.y, 7 * delta)
	#rotation.z = gun_pos.global_rotation.z
	
	
	# Declare mouse is no longer moving at the end of the frame
	mouse_axis = Vector2.ZERO


func anim_landing(p0: float, p1: float, t: float):
	# Using min() ensures whole animation plays out
	var q0 = lerpf(p0, p1, min(t, 1.0))
	var q1 = lerpf(p1, p0, min(t, 1.0))
	var r = lerpf(q0, q1, min(t, 1.0))
	return r
