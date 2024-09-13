extends CharacterBody2D

@onready var collision_shape = $Area2D/CollisionShape2D;
@onready var area: Area2D = %Area2D;
@onready var timer: Timer = %Timer;

@export var magnetic_force: float = 800.0
@export var detection_radius: float = 50.0
@export var attraction_speed: float = 200.0
@export var item: Node;
@export var drop_speed: float = 80.0;
@export var pickup_timeout: float = .25;

var player_body = null;
var timer_completed = false;
var item_added = false;
var random_direction;

func _ready():
	# Adjust the magnetic area collision shape size
	collision_shape.shape.radius = detection_radius
	# Connect the area_entered signal
	area.connect("body_entered", self._on_body_entered)
	area.connect("body_exited", self._on_body_exited)
	timer.wait_time = pickup_timeout;
	random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * (randf() * 50);

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
	if !timer_completed:
		velocity = random_direction;
		move_and_slide();
	elif player_body && timer_completed:
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
