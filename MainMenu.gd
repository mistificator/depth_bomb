extends Control

# Declare member variables here. 
onready var G = get_node("/root/GlobalVars")

func _ready():
	$Highscore.text = "HIGHSCORE: " + str(G.highscore)

	get_tree().get_root().connect("size_changed", self, "_size_changed")
	_size_changed()
	
func _size_changed():
	$Title.rect_position = get_viewport().get_visible_rect().size / 2
	$Title.rect_position.y -= 200
	$Sprite.position = get_viewport().get_visible_rect().size / 2
	$Sprite.position.x += 100
	$Sprite.position.y -= 100

func _on_Menu_itemSelected(index):
	if index == 0:
		G.reset()
		get_tree().change_scene("res://MainScene.tscn")
	elif index == 1:
		get_tree().change_scene("res://MainScene.tscn")
	elif index == 2:
		G.save_score()
		get_tree().quit()
