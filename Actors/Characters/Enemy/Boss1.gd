extends "res://Actors/Characters/Enemy/Enemy.gd"

signal boss_killed

var HomingBullet = preload("res://Actors/Projectiles/DelayedHomingBullet.tscn")

var spread_dark = false
var homing_dark = false

enum {PHASE1, PHASE2, PHASE3, PHASE4}

# Phase info
var curr_phase = PHASE1
var phase2_breakpoint = 9000
var phase3_breakpoint = 6000
var phase4_breakpoint = 3000
var spread_bullets = 8
var spread_bullet_speed = 75
var homing_bullet_speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
    gravity = 0
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func get_hit(damage):
    if hp > phase2_breakpoint && hp - damage <= phase2_breakpoint:
        curr_phase = PHASE2
        spread_bullets = 32
        spread_bullet_speed = 50
        homing_bullet_speed = 100
        spread_dark = false
    elif hp > phase3_breakpoint && hp - damage <= phase3_breakpoint:
        $SpreadTimer.wait_time = 1.1
        $HomingTimer.wait_time = .6
        spread_bullet_speed = 40
        homing_dark = true
        curr_phase = PHASE3
        spread_bullets = 64
    elif hp > phase4_breakpoint && hp - damage <= phase4_breakpoint:
        print ("PHASE 4")
        curr_phase = PHASE4
        spread_bullets = 64
        # Delay the spread timer so it's not unfair, reset it in the timeout
        $SpreadTimer.wait_time = 6
        $SpreadTimer.stop()
        $SpreadTimer.start()
        $HomingTimer.wait_time = .4
        spread_bullet_speed = 200
        homing_bullet_speed = 200

    if (hp - damage <= 0):
        emit_signal("boss_killed")
        
    .get_hit(damage)

func _on_SpreadTimer_timeout():
    if curr_phase == PHASE1:
        _spread(-1.5 * PI, -PI, false, spread_bullets, spread_dark, false, spread_bullet_speed)
        _spread(PI, 1.5 * PI, false, spread_bullets, not spread_dark, false, spread_bullet_speed)
        spread_dark = not spread_dark
    elif curr_phase == PHASE2 || curr_phase == PHASE3 || curr_phase == PHASE4:
        _spread(PI, 2 * PI, false, spread_bullets, spread_dark, false, spread_bullet_speed)
        spread_dark = not spread_dark

    if curr_phase == PHASE4:
        # Set the timer here because we delay it at first
        $SpreadTimer.wait_time = 1
        
func _on_HomingTimer_timeout():
    var point1 = Vector2(250, 250)
    var point2 = Vector2(750, 250)
    
    if curr_phase == PHASE1:
        _shoot_at_position(point1, HomingBullet, false, homing_bullet_speed)
        _shoot_at_position(point2, HomingBullet, false, homing_bullet_speed)
    elif curr_phase == PHASE2 || curr_phase == PHASE3 || curr_phase == PHASE4:
        _shoot_at_position(point1, HomingBullet, homing_dark, homing_bullet_speed)
        _shoot_at_position(point2, HomingBullet, homing_dark, homing_bullet_speed)
        homing_dark = not homing_dark
    
    pass # Replace with function body.

