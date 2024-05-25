extends Node2D

@export var loading_text: String = 'Loading...';

func _physics_process(delta):
	var label: Label = $CanvasLayer/ColorRect/LoadingText;
	label.text = loading_text
