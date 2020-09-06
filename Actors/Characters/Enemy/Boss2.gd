extends "res://Actors/Characters/Enemy/Enemy.gd"

var HomingBullet = preload("res://Actors/Projectiles/DelayedHomingBullet.tscn")
var MultiBullet = preload("res://Actors/Projectiles/MultiBullet.tscn")
var HomingMultiBullet = preload("res://Actors/Projectiles/HomingMultiBullet.tscn")

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
var alternating_spread = false

onready var animation = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
    gravity = 0
    $AnimatedSprite.play("default")
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func get_hit(damage):
    if hp > phase2_breakpoint && hp - damage <= phase2_breakpoint:
        $SpreadTimer.wait_time = 6
        curr_phase = PHASE2
        spread_bullets = 32
        spread_bullet_speed = 50
        homing_bullet_speed = 100
        spread_dark = false
    elif hp > phase3_breakpoint && hp - damage <= phase3_breakpoint:
        curr_phase = PHASE3
        $SpreadTimer.wait_time = 2
        #$HomingTimer.wait_time = .6
        spread_bullet_speed = 50
        homing_dark = true
        spread_bullets = 64
    elif hp > phase4_breakpoint && hp - damage <= phase4_breakpoint:
        curr_phase = PHASE4
        $SpreadTimer.wait_time = 1.75
        #$HomingTimer.wait_time = .6
        spread_bullet_speed = 50
        homing_dark = true
        spread_bullets = 32

    if (hp - damage <= 0):
        animation.play("die")
        yield(animation, "animation_finished")
        emit_signal("boss_killed")
        
    .get_hit(damage)

func _on_SpreadTimer_timeout():
    if curr_phase == PHASE1:
        var mb = MultiBullet.instance()
        mb.speed = 250
        mb.wait_time = 0.05
        mb.shot_rotation = 0.05
        mb.bullets = 4
        mb.alternating_style = mb.ALTERNATING_STYLE.NON_ALTERNATING
        mb.bullet_speed = 100
        mb.dark = spread_dark
        print(mb.alternating_style)
        spread_dark = not spread_dark
    
        _spread_with_multibullet(1.25 * PI, 1.75 * PI, true, 2, false, true, mb)
        alternating_spread = not alternating_spread
    elif curr_phase == PHASE2:
        var mb = MultiBullet.instance()
        mb.speed = 80
        mb.wait_time = 0.1
        mb.shot_rotation = 0.05
        mb.bullets = 16
        mb.alternating_style = mb.ALTERNATING_STYLE.ALTERNATE_EVERY_BULLET
        mb.bullet_speed = 200
        mb.dark = spread_dark
        print(mb.alternating_style)
        spread_dark = not spread_dark
    
        _spread_with_multibullet(1.5 * PI, 1.5 * PI, true, 1, false, false, mb)
        alternating_spread = not alternating_spread
    elif curr_phase == PHASE3:
        var mb = MultiBullet.instance()
        mb.speed = 400
        mb.wait_time = 0.025
        mb.shot_rotation = 0.05
        mb.bullets = 2
        mb.alternating_style = mb.ALTERNATING_STYLE.NON_ALTERNATING
        mb.bullet_speed = 200
        mb.dark = spread_dark
        print(mb.alternating_style)
        spread_dark = not spread_dark
        
        _spread_with_multibullet(1.25 * PI, 1.75 * PI, true, 3, spread_dark, true, mb)
    elif curr_phase == PHASE4:
        var mb = HomingMultiBullet.instance()
        mb.speed = 400
        mb.wait_time = 0.025
        mb.shot_rotation = 0.05
        mb.bullets = 4
        mb.alternating_style = mb.ALTERNATING_STYLE.NON_ALTERNATING
        mb.bullet_speed = 180
        mb.dark = spread_dark
        print(mb.alternating_style)
        spread_dark = not spread_dark
        
        if alternating_spread:
            _spread_with_multibullet(1.25 * PI, 1.25 * PI, true, 1, false, false, mb)
            alternating_spread = not alternating_spread
        else:
            _spread_with_multibullet(1.75 * PI, 1.75 * PI, true, 1, true, true, mb)
            alternating_spread = not alternating_spread
    
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

# Overwrting _spread because I'm too lazy to fix the parameters on the old one and make it work in all files
func _spread_with_multibullet(startRot, endRot, clockwise, bullets, dark, alternating_dark, projectile):
    var currAngle = startRot
    
    var angleDiff = 0
    if bullets > 1:
        angleDiff = (endRot - startRot) / float(bullets - 1)
    
    if not clockwise:
        angleDiff = (2 * PI) - angleDiff
        
    for i in range(bullets):
        var b = projectile.duplicate()
        b.dark = dark
        b.start(position, currAngle, false, dark)
        currAngle += angleDiff
        
        get_parent().add_child(b)
        if alternating_dark:
            dark = not dark
