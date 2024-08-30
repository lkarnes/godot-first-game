extends CharacterBody2D

@export var magnetic_force: float = 800.0
@export var detection_radius: float = 50.0
@export var attraction_speed: float = 200.0
@export var item: Node;

var player_body = null;
var timer_completed = false;
var item_added = false;

func _ready():
	# Adjust the magnetic area collision shape size
	$Area2D/CollisionShape2D.shape.radius = detection_radius
	
	# Connect the area_entered signal
	%Area2D.connect("body_entered", self._on_body_entered)
	%Area2D.connect("body_exited", self._on_body_exited)

func _on_body_entered(body):
	if body.name == 'Player':
		player_body = body

func _on_body_exited(body):
	if  body.name == 'Player':
		player_body = null

func _physics_process(delta):
	if item && !item_added:
		add_child(item);
		item_added = true;
	
	if player_body && timer_completed:
		var direction = (player_body.global_position - global_position).normalized()
		var distance = player_body.global_position.distance_to(global_position);
		velocity = direction * attraction_speed
		move_and_slide();
		if distance < 2:
			var response = Player.add_to_player_inventory(item);
			if response:
				remove_child(item);
				queue_free();

# adds a delay where the item cannot be picked up
func _on_timer_timeout():
	timer_completed = true;
