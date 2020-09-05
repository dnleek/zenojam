extends MarginContainer


onready var hp_bar = $HpBar


# Called when the node enters the scene tree for the first time.
func _ready():
    var player = $"../../Player"
    hp_bar.max_value = player.max_hp
    hp_bar.value = player.hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Player_health_changed(player_health):
    hp_bar.value = player_health
