extends Node2D

func _ready():
	const TREE = preload("res://scenes/trees/pine/pine_tree.tscn")
	var tree = TREE.instantiate();
	add_child(tree);
