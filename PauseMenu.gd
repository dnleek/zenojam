extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
    $Control.hide()
    # make sure pausing doesn't disable the pause screen
    pause_mode = Node.PAUSE_MODE_PROCESS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_just_pressed("ui_pause"):
        get_tree().paused = not get_tree().paused
        if get_tree().paused:
            $Control.show()
        else:
            $Control.hide()
