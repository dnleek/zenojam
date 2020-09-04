extends KinematicBody2D

# Movement parameters
export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200

# Health parameters
export (int) var max_hp = 100

var velocity = Vector2()
var jumping = false
var hp

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    hp = max_hp
    add_to_group("characters")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func get_hit(damage):
    print("took damage")
    
    hp -= damage
    
    if hp <= 0:
        queue_free()
