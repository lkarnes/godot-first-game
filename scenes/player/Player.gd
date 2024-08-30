extends CharacterBody2D

const SPEED = 250;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var primary_hand: Marker2D = %PrimaryPivot/PrimaryHand;
@onready var projetile_summon_point: Marker2D = %ProjectileSummonPoint;
@onready var primary_pivot: Marker2D = %PrimaryPivot;
var in_animation = false;

func _physics_process(delta):
	if !Player.player || !is_instance_valid(Player.player):
		Player.player = self;
	var primary_attack = Input.is_action_just_pressed('primary_attack');
	var secondary_attack = Input.is_action_just_pressed('secondary_attack');
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	
	var mouse_direction = get_mouse_direction();
	
	if 'left' in mouse_direction:
		Player.orientation = 'left';
	elif 'right' in mouse_direction:
		Player.orientation = 'right';
	
	move_and_slide();
	handle_animations(primary_attack, secondary_attack, direction);
	aim_primary();

func aim_primary():
	if !in_animation:
		var mouse_pos = get_global_mouse_position();
		var angle = (mouse_pos - global_position).angle();
		primary_pivot.rotation = angle;

# Create a function to calculate the new position based on the angle
func get_position_for_angle(angle_degrees):
	var angle_radians = deg_to_rad(angle_degrees)
	var radius = 180;
	return global_position + Vector2(radius * cos(angle_radians), radius * sin(angle_radians))

	
func handle_animations(primary_attack, secondary_attack, direction):
	if primary_attack and not in_animation:
		primary_pivot.visible = true;
		var item_in_hand = primary_hand.get_child(0);
		if item_in_hand:
			item_in_hand.get_node('HitBox').disabled = false;
		
		in_animation = true;
		var tween = get_tree().create_tween()
		primary_pivot.rotation = primary_pivot.rotation - 1;
		# Get the current rotation in degrees
		var current_rotation = primary_pivot.rotation - 1;

		# Calculate the target rotation, which is current_rotation + 180 degrees
		var target_rotation = current_rotation + 4;

		# Tween the rotation to the target rotation
		tween.tween_property(primary_pivot, "rotation", target_rotation, 0.3)
		tween.play()
		
		# Wait for the tween to finish
		await tween.step_finished
		item_in_hand.get_node('HitBox').disabled = true;
		in_animation = false;
		primary_pivot.visible = false;
		
	if secondary_attack && animation_player.animation_finished:
		const PROJECTILE = preload('res://scenes/objects/projectiles/fire_ball_1.tscn');
		var projectile = PROJECTILE.instantiate()
		projectile.global_position = projetile_summon_point.global_position;
		get_parent().add_child(projectile);
	
	if !primary_attack && !secondary_attack:
		# Determine the animation to play based on direction and orientation
		if direction.x != 0 || direction.y != 0:  # Moving left
			if Player.orientation == 'left':
				animation_player.play('run_left')  # Play reverse animation
				if direction.x < 0:
					animation_player.speed_scale = -1;
				else:
					animation_player.speed_scale = 1;
			else:
				animation_player.play('run_right')   # Play normal animation
				if direction.x > 0:
					animation_player.speed_scale = -1;
				else:
					animation_player.speed_scale = 1;
		else:
			animation_player.play('idle-' + Player.orientation)
			animation_player.speed_scale = 1  # Ensure idle animation plays normally

	
func get_mouse_direction():
	var mouse_pos = get_global_mouse_position()
	var node_pos = global_position
	var direction = mouse_pos - node_pos;

	if direction.x == 0 and direction.y == 0:
		return

	var angle = direction.angle()
	if angle > -PI/8 and angle <= PI/8:
		return 'right';
	elif angle > PI/8 and angle <= 3*PI/8:
		return 'bottom-right';
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		return 'bottom';
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		return 'bottom-left';
	elif angle <= -PI/8 and angle > -3*PI/8:
		return 'top-right';
	elif angle <= -3*PI/8 and angle > -5*PI/8:
		return 'top';
	elif angle <= -5*PI/8 and angle > -7*PI/8:
		return 'top-left';
	else:
		return 'left'
		
# helpers
func get_primary_hand():
	primary_hand.get_child(0);

func remove_primary_hand():
	primary_hand.remove_child(primary_hand.get_child(0));

func add_to_primary_hand(item):
	if primary_hand.get_children().size() > 0:
		primary_hand.remove_child(primary_hand.get_child(0));
	primary_hand.add_child(item);
