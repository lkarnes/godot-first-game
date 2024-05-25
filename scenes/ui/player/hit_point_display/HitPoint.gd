extends Node2D

@export var value = 100;

func _ready():
	%Label.text = str(value);
	%AnimationPlayer.play('fade');
	await %AnimationPlayer.animation_finished;
	queue_free();
