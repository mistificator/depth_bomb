extends ItemList

# Declare member variables here. 

var prev_selected = -1

var newgame_scene
var continue_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	select(0)
	grab_focus()
	get_tree().get_root().connect("size_changed", self, "_size_changed")
	_size_changed()

func _size_changed():
	rect_position = get_viewport().get_visible_rect().size / 2

func _on_Menu_item_selected(index):
	if prev_selected == index:
		_on_Menu_item_activated(index)
	prev_selected = index

func _on_Menu_item_activated(index):
	if get_tree().get_current_scene().get_name() == "MainMenu":
		if index == 0:
			get_tree().change_scene(newgame_scene)
		elif index == 1:
			get_tree().change_scene(continue_scene)
		elif index == 2:
			get_tree().quit()
	elif get_tree().get_current_scene().get_name() == "InGameMenu":
		if index == 0:
			get_tree().change_scene(continue_scene)
		elif index == 1:
			get_tree().change_scene("res://MainMenu.tscn")		
			
func setScenes(_newgame_scene, _continue_scene):
	newgame_scene = _newgame_scene
	continue_scene = _continue_scene			

