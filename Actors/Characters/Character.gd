extends KinematicBody2D

# Movement parameters
export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200

# Health parameters
export (int) var max_hp = 100

export (bool) var is_dark = false
signal health_changed

export (Resource) var Projectile = preload("res://Actors/Projectiles/Bullet.tscn")

var velocity = Vector2()
var jumping = false
var hp

# Called when the node enters the scene tree for the first time.
func _ready():
    hp = max_hp
    $Hurtbox.add_to_group("characters")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func get_hit(damage):
    hp -= damage
    emit_signal("health_changed", hp)
    
    if hp <= 0:
        queue_free()
