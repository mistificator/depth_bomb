extends StaticBody2D

# Declare member variables here. 

onready var U = preload("Utils.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "_size_changed")

func _size_changed():
	U.resizeSprite(self)
	U.makeCollisionPolygon(self, true)

func _on_Sprite_texture_changed():
	_size_changed()

func setTexture(_texture):
	$Sprite.texture = load(_texture)
	

