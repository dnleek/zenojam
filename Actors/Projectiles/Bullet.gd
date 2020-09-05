extends Area2D

export var speed = 250
export var damage = 10

var velocity = Vector2()
var is_player_bullet

func start(pos, dir, player_bullet):
    rotation = dir
    position = pos
    velocity = Vector2(speed, 0).rotated(rotation)
    set_rotation(rotation + PI / 2)
    is_player_bullet = player_bullet
    if is_player_bullet:
        velocity *= 4
    
    _set_layer(is_player_bullet)

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("VisibilityNotifier2D").connect("screen_exited", self, "_on_screen_exited")
    connect("body_entered", self, "_on_body_enter")


func _process(delta):
        position += velocity * delta

func _on_screen_exited():
    queue_free()
    
func _on_body_enter(body):
    if body.is_in_group("characters"):
        body.get_hit(damage)
    
    queue_free()

func _set_layer(is_player_bullet):
    if is_player_bullet:
        # Only collide with enemy layer
        set_collision_mask(2)
    else:
        # Only collide with player layer
        set_collision_mask(1)
