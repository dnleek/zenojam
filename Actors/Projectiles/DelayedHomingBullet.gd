extends "res://Actors/Projectiles/Bullet.gd"

export (int) var bullets = 8
# Every time this fires off a barrage, it will rotate the next barrage by this much
export (float) var shot_rotation = -15
export (float) var wait_time = .5

var Bullet = preload("res://Actors/Projectiles/Bullet.tscn")
var curr_shot_rotation = 0
var dark = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_HomeTimer_timeout():
    # Find player and rotate towards them
    var player_group = get_tree().get_nodes_in_group("Player")
    
    
    if player_group:
        var player = player_group[0]
        var rot = player.global_position - global_position
        rotation = rot.angle()

        velocity = Vector2(speed, 0).rotated(rotation)
