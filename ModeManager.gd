extends Node

var is_dark = false

func _process(delta):
    if Input.is_action_just_pressed("invert"):
        is_dark = not is_dark
