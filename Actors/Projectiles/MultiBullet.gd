extends "res://Actors/Projectiles/Bullet.gd"

export (int) var bullets = 8

var Bullet = preload("res://Actors/Projectiles/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_Timer_timeout():
    var angle = (PI * 2) / bullets
    var curr_rot = rotation
    
    for i in range(bullets):
        var b = Bullet.instance()
        b.start(position, curr_rot, is_player_bullet)
        get_parent().add_child(b)
        curr_rot += angle
    
