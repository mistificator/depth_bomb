extends RigidBody2D

# Declare member variables here.

onready var U = preload("Utils.gd").new()
var xscale = 1.0
var yscale = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().connect("size_changed", self, "_size_changed")

func _size_changed():
	U.resizeSprite(self, xscale, yscale)
	U.makeCollisionPolygon(self)

func _on_Sprite_texture_changed():
	_size_changed()

func setScale(_xscale, _yscale):
	xscale = _xscale
	yscale = _yscale
	_size_changed()

func _on_StaticObject_mouse_entered():
	if $Polygon.visible:
		$Tooltip.visible = true

func _on_StaticObject_mouse_exited():
	$Tooltip.visible = false

func setTexture(_texture):
	$Sprite.texture = load(_texture)

func setSize(_xsize, _ysize):
	setScale(_xsize / $Sprite.texture.get_size().x, _ysize / $Sprite.texture.get_size().y)

func size():
	return Vector2(xscale, yscale) * $Sprite.texture.get_size()
		
func sizeScaled():
	return $Sprite.scale * $Sprite.texture.get_size()