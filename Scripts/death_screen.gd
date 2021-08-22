extends Control

onready var prompt: Label = $"cont/title/Label"
onready var mm: Button = $"cont/cont/options/menu/button"
onready var play: Button = $"cont/cont/options/play/button"

func _ready():
	mm.connect("button_down", self, "_on_mm")
	play.connect("button_down", self, "_on_play")
	prompt.text = "My liege, the castle was destroyed by those vermin.\n You managed to survive %d waves,\n\n while killing %d of those peasants,\n quite an achievement your Highness." % [Global.wave_number , Global.enemies_defeated]
	$AudioStreamPlayer.play()
func _on_mm():
	get_tree().change_scene("res://Scenes/title_screen.tscn")

func _on_play():
	get_tree().change_scene("res://Scenes/game.tscn")
