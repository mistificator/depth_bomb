extends Camera2D

# Declare member variables here. 
onready var G = get_node("/root/GlobalVars")
var explosion_ref_size = Vector2(50, 200)

var vel_mouse_mul = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	$Background.setTexture("res://background.png")
	$Ship.setTexture("res://ship.png")
	$Bomb.setTexture("res://bomb.png")
	$Submarine.setTexture("res://submarine.png")
	$Explosion.setTexture("res://explosion.png")
	$Fish.setTexture("res://fish.png")
	
	$Ship.setSize(100, 30)
	$Bomb.setSize(20, 40)
	$Submarine.setSize(180, 20)
	$Explosion.setSize(explosion_ref_size.x, explosion_ref_size.y)	
	$Fish.setSize(80, 100)
	
	$Explosion.visible = false

	loadState()	
	
	if $Ship.position == Vector2(0, 0):
		$Ship.position = Vector2(get_viewport_rect().end.x / 2 - $Ship.sizeScaled().x / 2, 0.145 * get_viewport_rect().end.y)

	get_tree().get_root().connect("size_changed", self, "_size_changed")
	_size_changed()

func _size_changed():
#	offset = Vector2(get_viewport_rect().end.x / 2, get_viewport_rect().end.y / 2)
	$Label.rect_position.x = get_viewport_rect().end.x - $Label.rect_size.x * $Label.rect_scale.x

func bomb_throw():
	if !$Bomb.visible:
		$Bomb.position.x = $Ship.position.x + $Ship.sizeScaled().x / 2
		$Bomb.position.y = $Ship.position.y + $Ship.sizeScaled().y
		$Bomb/Sprite.set_flip_h(rand_range(0, 2) >= 1)
		$Bomb.visible = true		
		
func ship_left():
	G.vel.x = max(G.vel.x - vel_mouse_mul * G.vel_step, -G.max_vel)
	if G.vel.x < 0:
		$Ship/Sprite.set_flip_h(true)

func ship_right():
	G.vel.x = min(G.vel.x + vel_mouse_mul * G.vel_step, G.max_vel)
	if G.vel.x > 0:
		$Ship/Sprite.set_flip_h(false)	
		
func bomb_check_lost():
	if $Bomb.visible:
		$Bomb.position.y += G.bomb_vel * $Background/Sprite.scale.y
		if ($Bomb.position.y > $Ship.position.y + $Ship.sizeScaled().y + 150 * $Background/Sprite.scale.y):
			$Bomb.visible = false
			G.count -= 1	
			
func submarine_init():
	if rand_range(0, 2) >= 1:
		$Submarine.position.x = -$Submarine.sizeScaled().x
		$Submarine/Sprite.set_flip_h(false)
		G.submarine_vel = rand_range(1, max(2, G.count / 5.0)) * $Background/Sprite.scale.y
	else:
		$Submarine.position.x = get_viewport_rect().end.x + $Submarine.sizeScaled().x
		$Submarine/Sprite.set_flip_h(true)
		G.submarine_vel = - rand_range(1, max(2, G.count / 5.0)) * $Background/Sprite.scale.y
	$Submarine.position.y = rand_range($Ship.position.y + 2 * $Ship.sizeScaled().y, 0.8 * get_viewport_rect().end.y)
	G.submarine_vel *= 1 - ($Submarine.position.y / get_viewport_rect().end.y)
	$Submarine.visible = true	
	
func submarine_check_runaway():
	if ($Submarine.position.x < -$Submarine.sizeScaled().x) || ($Submarine.position.x > get_viewport_rect().end.x + $Submarine.sizeScaled().x):
		$Submarine.visible = false
		G.count -= 1
		
func submarine_move():
	$Submarine.position.x += G.submarine_vel			
		
func fish_init():
	var val = rand_range(0, 1000)
	if val < 1:
		$Fish.position.x = -$Fish.sizeScaled().x
		$Fish/Sprite.set_flip_h(true)
		G.fish_vel = rand_range(0.5, 1) * $Background/Sprite.scale.y
	elif val > 999:
		$Fish.position.x = get_viewport_rect().end.x + $Fish.sizeScaled().x
		$Fish/Sprite.set_flip_h(false)
		G.fish_vel = - rand_range(0.5, 1) * $Background/Sprite.scale.y
	else:
		return
	$Fish.position.y = rand_range(0.5 * get_viewport_rect().end.y, 0.9 * get_viewport_rect().end.y)
	$Fish.visible = true			
		
func fish_check_runaway():
	if ($Fish.position.x < -$Fish.sizeScaled().x) || ($Fish.position.x > get_viewport_rect().end.x + $Fish.sizeScaled().x):
		$Fish.visible = false
		
func fish_move():
	$Fish.position.x += G.fish_vel			
		
func ship_move():		
	$Ship.move_and_slide(G.vel * $Background/Sprite.scale)
	if $Ship.position.x <= 2 || $Ship.position.x >= get_viewport_rect().end.x - $Ship.sizeScaled().x - 2:
		G.vel = Vector2(0, 0)	
		
func boom():
	if ($Bomb.visible && $Submarine.visible):
		$Submarine.visible = false
		$Bomb.visible = false
		G.count += 1
		G.highscore = max(G.count, G.highscore)
		print("BOOOOM!")
		explosion_init()		
		
func explosion_init():		
	$Explosion/Sprite.set_flip_h(rand_range(0, 2) >= 1)
	$Explosion.setSize(explosion_ref_size.x, explosion_ref_size.y)	
	$Explosion.position = $Bomb.position
	$Explosion.visible = true
		
func explosion_grow():
	if $Explosion.visible:
		if $Explosion.size().x > explosion_ref_size.x * 2:
			$Explosion.visible = false
			return
		$Explosion.setSize($Explosion.size().x + rand_range(0, 2), $Explosion.size().y + rand_range(0, 2))		
		$Explosion.position = $Bomb.position
				
func _process(delta):
	ship_move()
	bomb_check_lost()
	explosion_grow()
		
	if !$Submarine.visible:
		submarine_init()
	else:
		submarine_move()
		submarine_check_runaway()
		
	if !$Fish.visible:
		fish_init()
	else:
		fish_move()
		fish_check_runaway()		

	if G.count < 0:
		G.count = 0 
	$Label.text = "SCORE: " + str(G.count)
	
	if Input.is_action_pressed("ui_cancel"):
		saveState()
		get_tree().change_scene("res://InGameMenu.tscn")		
		return	
	if Input.is_action_pressed("ui_left"):
		ship_left()
	if Input.is_action_pressed("ui_right"):
		ship_right()
	if Input.is_action_pressed("ui_select"):
		bomb_throw()		
		
func _input(event):		
	if event is InputEventMouseButton:
		if event.pressed:
			if (event.position.x < get_viewport_rect().end.x / 3):
				vel_mouse_mul = G.vel_mouse_mul
				ship_left()
				vel_mouse_mul = 1
			elif (event.position.x > 2 * get_viewport_rect().end.x / 3):	
				vel_mouse_mul = G.vel_mouse_mul
				ship_right()
				vel_mouse_mul = 1
			else:			
				bomb_throw()	
			
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST):
		print ("You are go back!")
		saveState()
		G.save_score()				
		get_tree().change_scene("res://InGameMenu.tscn")	
				
func _on_Submarine_body_entered(body):
	if body == $Bomb:
		boom()

func saveState():	
	G.bomb_pos = $Bomb.position / $Background/Sprite.scale
	G.submarine_pos = $Submarine.position / $Background/Sprite.scale
	G.fish_pos = $Fish.position / $Background/Sprite.scale
	
	G.ship_pos = $Ship.position / $Background/Sprite.scale
	
	G.bomb_visible = $Bomb.visible
	G.submarine_visible = $Submarine.visible
	G.fish_visible = $Fish.visible	
	
func loadState():
	$Bomb.position = G.bomb_pos * $Background/Sprite.scale
	$Submarine.position = G.submarine_pos * $Background/Sprite.scale
	$Fish.position = G.fish_pos * $Background/Sprite.scale
	
	$Ship.position = G.ship_pos * $Background/Sprite.scale	
	
	$Bomb.visible = G.bomb_visible
	$Submarine.visible = G.submarine_visible
	$Fish.visible = G.fish_visible

	if G.submarine_vel < 0:
		$Submarine/Sprite.set_flip_h(true)
		
	if G.fish_vel > 0:
		$Fish/Sprite.set_flip_h(true)