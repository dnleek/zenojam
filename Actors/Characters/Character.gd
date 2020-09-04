extends KinematicBody2D

# Movement parameters
export (int) var run_speed = 100
export (int) var jump_speed = -400
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group("characters")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func get_hit(damage):
    print("took damage")
