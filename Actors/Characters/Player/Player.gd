extends "res://Actors/Characters/Character.gd"

const FLOOR_NORMAL = Vector2.UP

onready var platform_detector = $PlatformDetector
var has_used_double_jump = false

# Let the user cancel the jump early by letting go of the jump key.
# cancel_jump_threshold is the minimum velocity at which point they can cancel,
# and cancel_jump_speed is what their speed will be set to after the jump gets
# cancelled.
export (int) var cancel_jump_speed = -100
export (int) var cancel_jump_threshold  = -250

# Shooting parameters
export (int) var shoot_cooldown = 500

# Shooting values
var next_shoot = 0 # Timestamp of when shooting is possible again
var is_on_platform = false
var is_facing_left = false

var slow_mode = false

onready var animation_player = $AnimatedSprite

signal player_killed

func _ready():
    add_to_group("Player")
    animation_player.play("default")

func get_input():
    get_movement_input()
    get_shooting_input()
    
func get_movement_input():
    if animation_player.animation == "die":
        velocity.x = 0
        velocity.y = 0
        # return here, otherwise die animation can be overridden by below code
        return
    animation_player.flip_h = is_facing_left
    is_on_platform = platform_detector.is_colliding()
    velocity.x = 0
    var right = Input.is_action_pressed('ui_right')
    var left = Input.is_action_pressed('ui_left')
    var jump = Input.is_action_pressed('ui_select') || Input.is_action_pressed('ui_up')
    var jump_just_pressed = Input.is_action_just_pressed('ui_select') || Input.is_action_just_pressed('ui_up')
    var slow = Input.is_action_pressed("slow")

    if right and left:
        animation_player.play("default")
    elif right:
        is_facing_left = false
        velocity.x += run_speed
        if is_on_floor():
            animation_player.play("walk")
    elif left:
        is_facing_left = true
        velocity.x -= run_speed
        if is_on_floor():
            animation_player.play("walk")
    elif not left and not right:
        if is_on_floor() and not jump:
            animation_player.play("default")
            
    slow_mode = slow   
    if slow_mode:
        velocity.x = velocity.x / 2
        $HurtboxVisible.show()
    else:
        $HurtboxVisible.hide()

    if jump_just_pressed:
        if is_on_floor() or is_on_platform:
            animation_player.play("jump")
            velocity.y = jump_speed
        elif (not has_used_double_jump):
            animation_player.frame = 0
            animation_player.play("jump")
            has_used_double_jump = true
            velocity.y = jump_speed
    if not jump and velocity.y < 0 and velocity.y >= cancel_jump_threshold:
        velocity.y = max(velocity.y, cancel_jump_speed)

func get_shooting_input():
    var shooting = Input.is_action_pressed('shoot')
    
    if shooting and can_shoot():
        shoot()
        next_shoot = OS.get_system_time_msecs() + shoot_cooldown

func can_shoot():
    return OS.get_system_time_msecs() > next_shoot

func shoot():
    var dir = get_global_mouse_position() - global_position
    var b = Projectile.instance()
    b.start(position, dir.angle(), true, false)
    get_parent().add_child(b)

func _physics_process(delta):
    get_input()
    velocity.y += gravity * delta
    velocity = move_and_slide_with_snap(velocity, Vector2(0, -1), FLOOR_NORMAL, not is_on_platform)
    if (is_on_floor()):
        has_used_double_jump = false

func _process(delta):
    # Update mask for light & dark layer bullet collisions.
    $Hurtbox.set_collision_layer_bit(0, not ModeManager.is_dark)
    $Hurtbox.set_collision_layer_bit(2, ModeManager.is_dark)
    set_collision_layer_bit(0, not ModeManager.is_dark)
    set_collision_layer_bit(2, ModeManager.is_dark)

func _on_RedPowerUp_powerup():
    shoot_cooldown = shoot_cooldown / 2


func _on_Kill_Floor_area_entered(area):
    if area == $Hurtbox:
        get_hit(69420)
    
func get_hit(damage):
    if (hp - damage <= 0):
        $HurtboxVisible.hide()
        animation_player.play("die")
        yield(animation_player, "animation_finished")
        emit_signal("player_killed", $Camera2D.get_camera_position())
    
    .get_hit(damage)
