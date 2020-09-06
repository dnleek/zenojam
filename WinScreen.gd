extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    $Control.hide()
    pause_mode = Node.PAUSE_MODE_PROCESS


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_level_start():
    $Control.hide()

func _on_Button_button_down():
    return
    get_tree().change_scene("res://Levels/Level1.tscn")


func _on_Level_level_win():
    get_tree().paused = true
    $Control.show()
