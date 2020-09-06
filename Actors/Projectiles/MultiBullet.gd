extends "res://Actors/Projectiles/Bullet.gd"

export (int) var bullets = 8
# Every time this fires off a barrage, it will rotate the next barrage by this much
export (float) var shot_rotation = -15
export (float) var wait_time = .5
export (float) var bullet_speed = 100

export (Resource) var Bullet = preload("res://Actors/Projectiles/Bullet.tscn")
var curr_shot_rotation = 0
export var dark = false

enum ALTERNATING_STYLE {NON_ALTERNATING, ALTERNATE_EVERY_TIMEOUT, ALTERNATE_EVERY_BULLET}
export (ALTERNATING_STYLE) var alternating_style = ALTERNATING_STYLE.ALTERNATE_EVERY_BULLET



# Called when the node enters the scene tree for the first time.
func _ready():
    $Timer.wait_time = wait_time
    pass # Replace with function body.

func _on_Timer_timeout():
    var angle = (PI * 2) / bullets
    var curr_rot = rotation + curr_shot_rotation
    curr_shot_rotation += shot_rotation
    if alternating_style == ALTERNATING_STYLE.ALTERNATE_EVERY_TIMEOUT:
        dark = not dark
    
    for i in range(bullets):
        var b = Bullet.instance()
        b.start(position, curr_rot, is_player_bullet, dark, bullet_speed)
        get_parent().add_child(b)
        curr_rot += angle
        if alternating_style == ALTERNATING_STYLE.ALTERNATE_EVERY_BULLET:
            dark = not dark
