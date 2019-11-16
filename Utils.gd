extends Node

func resizeSprite(node, xscale = 1.0, yscale = 1.0):
	if node.get_node("Sprite").texture == null:
		return
	var prev_scale = node.get_node("Sprite").scale
	var image_size = node.get_node("Sprite").texture.get_size()
	var window_size = node.get_viewport().get_visible_rect().size
	node.get_node("Sprite").scale = Vector2(xscale * window_size.x / image_size.x, yscale * window_size.y / image_size.y)
	node.get_node("Sprite").offset = image_size / 2	
	if (node.get_node("Sprite").get_parent()):
		node.get_node("Sprite").get_parent().position *= node.get_node("Sprite").scale / prev_scale

func makeCollisionPolygon(node, wirebox = false):
	var rect = node.get_node("Sprite").get_rect()
	rect.size *= node.get_node("Sprite").scale
	var poly = rectToPoly(rect, wirebox)
	node.get_node("Collision").polygon = poly
	if (node.get_node("Polygon") != null):
		node.get_node("Polygon").polygon = poly
		node.get_node("Polygon").color = Color(1, 1, 1, 0.2)
	if (node.get_node("Tooltip") != null):
		node.get_node("Tooltip").text = node.name
		node.get_node("Tooltip").rect_position = Vector2(rect.position.x + (rect.size.x / 2), rect.position.y - node.get_node("Tooltip").rect_size.y)

func rectToPoly(rect, wirebox = false):
	var v = PoolVector2Array()
	v.push_back(rect.position)
	v.push_back(Vector2(rect.position.x + rect.size.x, rect.position.y))
	v.push_back(Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y))
	v.push_back(Vector2(rect.position.x, rect.position.y + rect.size.y))

	if wirebox:
		v.push_back(Vector2(rect.position.x, rect.position.y + 1))
		v.push_back(Vector2(rect.position.x + 1, rect.position.y + 1))
		v.push_back(Vector2(rect.position.x + 1, rect.position.y + rect.size.y - 1))
		v.push_back(Vector2(rect.position.x + rect.size.x - 1, rect.position.y + rect.size.y - 1))
		v.push_back(Vector2(rect.position.x + rect.size.x - 1, rect.position.y + 1))
		v.push_back(Vector2(rect.position.x, rect.position.y + 0.999999))

	v.push_back(rect.position)
	return v