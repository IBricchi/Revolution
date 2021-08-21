extends Control

onready var castle_health = $ProgressBar
func display_health(val):
	castle_health.value = val
