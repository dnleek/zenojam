extends CanvasLayer


onready var hp_bar = $HpBar
onready var boss_hp_bar = $BossHpBar
onready var player = $"../Player"
onready var boss = $"../Boss"


# Called when the node enters the scene tree for the first time.
func _ready():
    if player != null:
        hp_bar.max_value = player.max_hp
        hp_bar.value = player.hp
    else:
        hp_bar.hide()
    if boss != null:
        boss_hp_bar.max_value = boss.max_hp
        boss_hp_bar.value = boss.hp
    boss_hp_bar.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Player_health_changed(player_health):
    hp_bar.value = player_health


func _on_BossArena_body_entered(body):
    print(body)
    if body == player:
        print("is player")
        boss_hp_bar.show()


func _on_BossArena_body_exited(body):
    if body == player:
        boss_hp_bar.hide()


func _on_Boss_health_changed(boss_health):
    print(boss_health)
    boss_hp_bar.value = boss_health
