extends Node

# Declare member variables here. 
var vel = Vector2(0, 0)
var submarine_vel = 0
var fish_vel = 0
var count = 0

const max_vel = 100
const vel_step = 1
const vel_mouse_mul = 20
const bomb_vel = 1

var highscore = 0
var score_file = "user://highscore.txt"

var bomb_visible = false
var submarine_visible = false
var fish_visible = false

var bomb_pos = Vector2(0, 0)
var submarine_pos = Vector2(0, 0)
var fish_pos = Vector2(0, 0)
var ship_pos = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_auto_accept_quit(false)
	reset()
	load_score()
	print("GlobalVars loaded")

func reset():
	vel = Vector2(0, 0)
	submarine_vel = 0
	fish_vel = 0
	count = 0	

	bomb_visible = false
	submarine_visible = false
	fish_visible = false

	bomb_pos = Vector2(0, 0)
	submarine_pos = Vector2(0, 0)
	fish_pos = Vector2(0, 0)
	ship_pos = Vector2(0, 0)	
	
	print("GlobalVars reset")
	
func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		print ("You are quit!")
		save_score()
		get_tree().quit() 				

func load_score():
    var f = File.new()
    if f.file_exists(score_file):
        f.open(score_file, File.READ)
        var content = f.get_as_text()
        highscore = int(content)
        f.close()

func save_score():
    var f = File.new()
    f.open(score_file, File.WRITE)
    f.store_string(str(highscore))
    f.close()		