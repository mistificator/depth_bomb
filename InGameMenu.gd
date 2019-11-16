extends Control

func _on_Menu_itemSelected(index):
	if index == 0:
		get_tree().change_scene("res://MainScene.tscn")
	elif index == 1:
		get_tree().change_scene("res://MainMenu.tscn")		

