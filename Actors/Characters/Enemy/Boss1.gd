extends "res://Actors/Characters/Enemy/Enemy.gd"

var HomingBullet = preload("res://Actors/Projectiles/DelayedHomingBullet.tscn")

var spread_dark = false

# Called when the node enters the scene tree for the first time.
func _ready():
    gravity = 0
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_SpreadTimer_timeout():
    _spread(-1.5 * PI, -PI, false, 8, spread_dark, false, 75)
    _spread(PI, 1.5 * PI, false, 8, not spread_dark, false, 75)
    spread_dark = not spread_dark


func _on_HomingTimer_timeout():
    
    var point1 = Vector2(250, 250)
    var point2 = Vector2(750, 250)
    _shoot_at_position(point1, HomingBullet, true)
    _shoot_at_position(point2, HomingBullet, false)
    
    pass # Replace with function body.
