extends "res://Actors/Characters/Character.gd"


const FLOOR_NORMAL = Vector2.UP

onready var platform_detector = $PlatformDetector

# Let the user cancel the jump early by letting go of the jump key.
# cancel_jump_threshold is the minimum velocity at which point they can cancel,
# and cancel_jump_speed is what their speed will be set to after the jump gets
# cancelled.
export (int) var cancel_jump_speed = -100
export (int) var cancel_jump_threshold  = -250

# Shooting parameters
export (int) var shoot_cooldown = 500

var screen_size

# Shooting values
var Bullet = preload("res://Actors/Projectiles/Bullet.tscn")
var next_shoot = 0 # Timestamp of when shooting is possible again
var is_on_platform = false


func _ready():
    screen_size = get_viewport_rect().size

func get_input():
    get_movement_input()
    get_shooting_input()
    
func get_movement_input():
    is_on_platform = platform_detector.is_colliding()
    velocity.x = 0
    var right = Input.is_action_pressed('ui_right')
    var left = Input.is_action_pressed('ui_left')
    var jump = Input.is_action_pressed('ui_select') || Input.is_action_pressed('ui_up')
    var jump_just_pressed = Input.is_action_just_pressed('ui_select') || Input.is_action_just_pressed('ui_up')

    if jump_just_pressed:
        if is_on_floor() or is_on_platform:
            jumping = true
            velocity.y = jump_speed
    if not jump and velocity.y < 0 and velocity.y >= cancel_jump_threshold:
        velocity.y = max(velocity.y, cancel_jump_speed)
    if right:
        velocity.x += run_speed
    if left:
        velocity.x -= run_speed

func get_shooting_input():
    var shooting = Input.is_action_pressed('shoot')
    
    if shooting and can_shoot():
        shoot()
        next_shoot = OS.get_system_time_msecs() + shoot_cooldown

func can_shoot():
    return OS.get_system_time_msecs() > next_shoot

func shoot():
    var dir = get_global_mouse_position() - global_position
    var b = Bullet.instance()
    b.start(position, dir.angle(), true)
    get_parent().add_child(b)
    return true


func _physics_process(delta):
    get_input()
    velocity.y += gravity * delta
    velocity = move_and_slide_with_snap(velocity, Vector2(0, -1), FLOOR_NORMAL, not is_on_platform)
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
