extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sceneMap = {
    "Level": "res://Levels/Level1.tscn",
    "res://Levels/Level1": "res://Levels/LevelBattleField.tscn",
    "LevelBattleField": "res://Levels/LevelSmashville.tscn",
    "LevelSmashville": "res://Levels/LevelFinalDestination.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Boss_boss_killed():
    print("boss killed")
    get_tree().change_scene(sceneMap[get_tree().current_scene.name])
