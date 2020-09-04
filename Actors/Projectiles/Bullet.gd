extends KinematicBody2D

export var speed = 250
var velocity = Vector2()

func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	set_rotation(rotation + PI / 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VisibilityNotifier2D").connect("screen_exited", self, "_on_screen_exited")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	move_and_collide(velocity * delta)

func _on_screen_exited():
	queue_free()
