extends Panel

@export var mouseOverColor : Color
@export var originalColor : Color


func _ready():
	add_theme_color_override("font_color", originalColor)

func OnMouseOver():
	add_theme_color_override("font_color", mouseOverColor)

func OnMouseLeave():
	add_theme_color_override("font_color", originalColor)
