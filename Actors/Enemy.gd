extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false
var screen_size
var dir = 1

func _ready():
    screen_size = get_viewport_rect().size
    velocity.x = run_speed

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
