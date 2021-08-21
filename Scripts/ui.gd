extends PanelContainer

onready var money_indicator: Label = $"margin/list/moneydisplay" 

func _ready():
	display_money(get_parent().money)

func display_money(value):
	money_indicator.text = "Wealth: %d Florins" % value


