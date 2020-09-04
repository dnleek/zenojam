extends KinematicBody2D

export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200

# Let the user cancel the jump early by letting go of the jump key.
# cancel_jump_threshold is the minimum velocity at which point they can cancel,
# and cancel_jump_speed is what their speed will be set to after the jump gets
# cancelled.
export (int) var cancel_jump_speed = -100
export (int) var cancel_jump_threshold  = -250

var velocity = Vector2()
var jumping = false
var screen_size

func _ready():
    screen_size = get_viewport_rect().size

func get_input():
    velocity.x = 0
    var right = Input.is_action_pressed('ui_right')
    var left = Input.is_action_pressed('ui_left')
    var jump = Input.is_action_pressed('ui_select') || Input.is_action_pressed('ui_up')
    var jump_just_pressed = Input.is_action_just_pressed('ui_select') || Input.is_action_just_pressed('ui_up')

    if jump_just_pressed and is_on_floor():
        jumping = true
        velocity.y = jump_speed
    if not jump and velocity.y < 0 and velocity.y >= cancel_jump_threshold:
        velocity.y = max(velocity.y, cancel_jump_speed)

    if right:
        velocity.x += run_speed
    if left:
        velocity.x -= run_speed

func _physics_process(delta):
    get_input()
    velocity.y += gravity * delta
    if jumping and is_on_floor():
        jumping = false
    velocity = move_and_slide(velocity, Vector2(0, -1))
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
