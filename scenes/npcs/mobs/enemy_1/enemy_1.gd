extends CharacterBody2D

@onready var scan_radius: Area2D = %ScanRadius;
var walking_to_interest_point: bool = false;
var interest;
var cooldown = 0;

var speed = 35;

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D;

var priority_by_item_type = ['npc', 'foliage', 'other'];

func _physics_process(delta):
	if !walking_to_interest_point:
		check_for_interest_points();
	elif walking_to_interest_point:
		move_to_interest(delta);
	
func check_for_interest_points():
	var items_in_range = scan_radius.get_overlapping_bodies();
	if items_in_range.size() > 0:
		var new_interest;
		var new_interest_idx;
		items_in_range.shuffle();
		for item in items_in_range:
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
			cooldown -= delta;
		else:
			if distance > 20:
				var direction = to_local(nav_agent.get_next_path_position()).normalized();
				velocity = direction * speed;
				move_and_slide();
			else:
				check_for_interest_points();
				cooldown = randf() * 10;
		

func make_path():
	if "global_position" in interest:
		nav_agent.target_position = interest.global_position;
	else:
		check_for_interest_points();

func _on_timer_timeout():
	make_path();
