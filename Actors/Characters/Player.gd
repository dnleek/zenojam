extends KinematicBody2D

# Movement parameters
export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200

# Shooting parameters
export (int) var shoot_cooldown = 500

var velocity = Vector2()
var jumping = false

# Shooting values
var Bullet = preload("res://Actors/Projectiles/Bullet.tscn")
var next_shoot = 0 # Timestamp of when shooting is possible again

func get_input():
	get_movement_input()
	get_shooting_input()
	
func get_movement_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select') || Input.is_action_just_pressed('ui_up')

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed

func get_shooting_input():
	var shooting = Input.is_action_pressed('shoot')
	
	if shooting and can_shoot():
		print("shooting")
		shoot()

func can_shoot():
	return OS.get_system_time_msecs() > next_shoot

func shoot():
	var dir = get_global_mouse_position() - global_position
	var b = Bullet.instance()
	b.start(position, dir.angle())
	get_parent().add_child(b)
	return true


func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
