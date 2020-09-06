extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal level_start
signal level_win

var sceneMap = {
    "Level": "res://Levels/Level1.tscn",
    "Level 1": "res://Levels/Level.tscn",
    "LevelBattleField": "res://Levels/LevelSmashville.tscn",
    "LevelSmashville": "res://Levels/LevelFinalDestination.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
    $Camera2D.current = false
    emit_signal("level_start")
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _on_Boss_boss_killed():
    emit_signal("level_win")
    if get_tree().current_scene.name == "Level 3":
        return
    get_tree().change_scene(sceneMap[get_tree().current_scene.name])


func _on_Player_player_killed(camera_position):
    $Camera2D.position = camera_position
    $Camera2D.current = true
