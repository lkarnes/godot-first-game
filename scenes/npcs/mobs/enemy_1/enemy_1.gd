extends CharacterBody2D

@onready var scan_radius: Area2D = %ScanRadius;
var walking_to_interest_point: bool = false;
var interest;
var cooldown = 0;
var max_health = 200;
var health = 200;
var speed = 35;
var player_in_range = true;
var jump_direction; # used to keep angle of the jump

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var sprite: Sprite2D = %Sprite;

var priority_by_item_type = ['npc', 'foliage', 'other'];

func _physics_process(delta):
	if !walking_to_interest_point:
		check_for_interest_points();
	elif walking_to_interest_point && player_in_range:
		agro_player(delta);
	elif walking_to_interest_point:
		move_to_interest(delta);
	
func check_for_interest_points():
	var items_in_range = scan_radius.get_overlapping_bodies();
	if items_in_range.size() > 0:
		var new_interest;
		var new_interest_idx;
		items_in_range.shuffle();
		for item in items_in_range:
			# agro player
			if item.name == 'Player':
				player_in_range = true;
				interest = item;
				walking_to_interest_point = true;
				return;
			var item_type;
			if "type" in item:
				item_type = item.type;
			else:
				item_type = "other";
			var item_idx = priority_by_item_type.find(item_type, 0);
			if !new_interest || new_interest_idx > item_idx:
				new_interest = item;
				new_interest_idx = item_idx;
			interest = new_interest;
			walking_to_interest_point = true;
		
func move_to_interest(delta):
	if "global_position" in interest:
		var distance = global_position.distance_to(interest.global_position);
		if cooldown > 0:
			animation_player.play("idle");
			cooldown -= delta;
		else:
			if distance > 20:
				animation_player.play("walk");
				var direction = to_local(nav_agent.get_next_path_position()).normalized();
				velocity = direction * speed;
				move_and_slide();
			else:
				check_for_interest_points();
				cooldown = randf() * 10;

func agro_player(delta):
	if animation_player.current_animation.contains("jump"):
		velocity = jump_direction * speed * 2;
		move_and_slide();
		cooldown = randf() * 4;
		return;
	if "global_position" in interest:
		var distance = global_position.distance_to(interest.global_position);
		if cooldown > 0:
			animation_player.play("idle");
			cooldown -= delta;
		else:
			if distance > 40:
				animation_player.play("walk");
				var direction = to_local(nav_agent.get_next_path_position()).normalized();
				velocity = direction * speed;
				move_and_slide();
			else:
				# jump at the player
				var direction = to_local(nav_agent.get_next_path_position()).normalized();
				if direction.x < -0:
					animation_player.play("jump_left");
				else:
					animation_player.play("jump_right");
					
				velocity = direction * speed * 10;
				jump_direction = direction;
				move_and_slide();
				pass;

func make_path():
	if "global_position" in interest:
		nav_agent.target_position = interest.global_position;
	else:
		check_for_interest_points();

func _on_timer_timeout():
	make_path();
	
func take_damage(damage: float):
	health -= damage;
