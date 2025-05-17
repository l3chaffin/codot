extends Control

@onready var player = get_node("..")
var default_size = 80.0
var innaccuracy = 3

func _process(delta: float) -> void:
	$Crosshair.position.x = get_viewport().get_visible_rect().size.x / 2
	$Crosshair.position.y = get_viewport().get_visible_rect().size.y / 2
	
	if player.cur_speed > 0.0 or !player.is_on_floor():
		$Crosshair.size.x = lerp($Crosshair.size.x, default_size * innaccuracy, 4 * delta)
		$Crosshair.size.y = lerp($Crosshair.size.y, default_size * innaccuracy, 4 * delta)
		$Crosshair.pivot_offset.x = $Crosshair.size.x * 1.5
		$Crosshair.pivot_offset.y = $Crosshair.size.y * 1.5
		$Crosshair.modulate = lerp($Crosshair.modulate, Color(1, 1, 1, 0.5), 4 * delta)
	else:
		$Crosshair.size.x = lerp($Crosshair.size.x, default_size, 8 * delta)
		$Crosshair.size.y = lerp($Crosshair.size.y, default_size, 8 * delta)
		$Crosshair.pivot_offset.x = $Crosshair.size.x * 1.5
		$Crosshair.pivot_offset.y = $Crosshair.size.y * 1.5
		$Crosshair.modulate = lerp($Crosshair.modulate, Color(1, 1, 1, 1), 8 * delta)
