extends "res://Actors/Characters/Character.gd"

# Where they aim relative to player. Basically so multibullets don't get shot directly at player
export var aim_offset = Vector2(0, 0)
export var shoot_time = 1.0
# Random offset to add/subtract to the rotation for projectiles
export (float) var inaccuracy = 0

var screen_size
var dir = 1
var rand

func _ready():
    screen_size = get_viewport_rect().size
    velocity.x = run_speed
    $ShootTimer.wait_time = shoot_time
    rand = RandomNumberGenerator.new()
    rand.randomize()

func _physics_process(delta):
    velocity.x = run_speed * dir
    if jumping == true:
        velocity.y += jump_speed
        jumping = false

    velocity.y += gravity * delta
    if jumping and is_on_floor():
        jumping = false

    velocity = move_and_slide(velocity, Vector2(0, -1))
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)


func _on_Timer_timeout():
    dir = dir * -1

func _on_JumpTimer_timeout():
    if is_on_floor():
        jumping = true

func _on_ShootTimer_timeout():
    var player_group = get_tree().get_nodes_in_group("Player")
    
    if player_group:
        var player = player_group[0]
        var rot = player.global_position + aim_offset - global_position
        var angle_offset = rand.randf_range(0, inaccuracy) - (inaccuracy / 2)
        var angle = rot.angle() + angle_offset
        var b = Projectile.instance()
        b.start(position, angle, false)
        get_parent().add_child(b)
