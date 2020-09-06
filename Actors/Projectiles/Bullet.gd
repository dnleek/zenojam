extends Area2D

export var speed = 250
export var damage = 10

var velocity = Vector2()
var is_player_bullet
var is_dark

func start(pos, dir, player_bullet, dark, new_speed = 0):
    if new_speed:
        speed = new_speed
    rotation = dir
    position = pos
    is_player_bullet = player_bullet
    is_dark = dark
    
    velocity = Vector2(speed, 0).rotated(rotation)
    set_rotation(rotation + PI / 2)
    
    if player_bullet:
        velocity *= 4
    
    _set_layer(player_bullet, dark)

# Called when the node enters the scene tree for the first time.
func _ready():
    get_node("VisibilityNotifier2D").connect("screen_exited", self, "_on_screen_exited")
    connect("area_entered", self, "_on_area_enter")
    connect("body_entered", self, "_on_body_enter")


func _process(delta):
    position += velocity * delta
    var on_opposite_layer = (not ModeManager.is_dark and is_dark) or (ModeManager.is_dark and not is_dark)
    get_node("Sprite").modulate.a = 0.5 if on_opposite_layer else 1

func _on_screen_exited():
    queue_free()
    
func _on_area_enter(area):
    if area.is_in_group("characters"):
        area.owner.get_hit(damage)
        queue_free()
    
func _on_body_enter(body):
    if body is TileMap or body.name == "Platform":
        queue_free()

func _set_layer(player_bullet, dark):
    if player_bullet:
        # Only collide with enemy layer
        set_collision_mask(2)
    elif not dark:
        # Only collide with player light layer
        set_collision_mask(1)
    else:
        # Only collide with player dark layer
        set_collision_mask(4)
