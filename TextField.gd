extends Control

# Declare member variables here. 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Show.grab_focus()

	get_tree().get_root().connect("size_changed", self, "_size_changed")
	_size_changed()
	
func _size_changed():	
	$Area.rect_size.x = get_viewport().get_visible_rect().size.x
	$Area.rect_size.y = 100
	$Area.rect_position.y = get_viewport().get_visible_rect().size.y - $Area.rect_size.y
	
	_on_Show_toggled($Show.pressed)
	
func _on_Show_toggled(button_pressed):
	if button_pressed:
		$Area.visible = true
		$Show.text = "v"
		$Show.rect_position.y = $Area.rect_position.y
	else:
		$Area.visible = false
		$Show.text = "^"
		$Show.rect_position.y = get_viewport().get_visible_rect().size.y - $Show.rect_size.y
	$Show.rect_position.x = get_viewport().get_visible_rect().size.x - $Show.rect_size.x

func intercepted():
	return ($Area.visible && $Area.get_rect().has_point(get_viewport().get_mouse_position())) || $Show.get_rect().has_point(get_viewport().get_mouse_position())
