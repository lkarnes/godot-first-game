extends CharacterBody2D

@export var magnetic_force: float = 800.0
@export var detection_radius: float = 50.0
@export var attraction_speed: float = 200.0

var player = null

func _ready():
	# Adjust the magnetic area collision shape size
	$Area2D/CollisionShape2D.shape.radius = detection_radius
	
	# Connect the area_entered signal
	%Area2D.connect("body_entered", self._on_body_entered)
	%Area2D.connect("body_exited", self._on_body_exited)

func _on_body_entered(body):
	print('entered:', body.name);
	if body.name == 'Player':
		player = body

func _on_body_exited(body):
	if body == player:
		player = null

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		var distance = player.global_position.distance_to(global_position);
		velocity = direction * attraction_speed
		move_and_slide()
		
		if distance < 2:
			queue_free()
