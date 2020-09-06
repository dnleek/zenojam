extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    $Control.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Button_button_down():
    get_tree().change_scene("res://Levels/Level1.tscn")


func _on_level_start():
    $Control.hide()


func _on_player_killed(_camera_position):
    $Control.show()
