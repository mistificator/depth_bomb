extends Control

# Declare member variables here. 

var prev_selected = -1

signal itemSelected(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	$List.select(0)
	$List.grab_focus()
	get_tree().get_root().connect("size_changed", self, "_size_changed")
	_size_changed()

func _size_changed():
	$List.rect_position = get_viewport().get_visible_rect().size / 2
			
func _on_List_item_activated(index):
	emit_signal("itemSelected", index)

func _on_List_item_selected(index):
	if prev_selected == index:
		_on_List_item_activated(index)
	prev_selected = index
