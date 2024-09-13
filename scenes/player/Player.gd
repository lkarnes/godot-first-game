extends CharacterBody2D

const SPEED = 150;
@onready var animation_player: AnimationPlayer = %AnimationPlayer;
@onready var primary_hand: Marker2D = %PrimaryPivot/PrimaryHand;
@onready var projetile_summon_point: Marker2D = %ProjectileSummonPoint;
@onready var primary_pivot: Marker2D = %PrimaryPivot;
@onready var cursor: Area2D = %Cursor;
var in_animation = false;

func _physics_process(delta):
	Player.mana = Player.mana + (1 * delta);
	if !Player.player || !is_instance_valid(Player.player):
		Player.player = self;
	var tool_action = Input.is_action_just_pressed('tool_action');
	var spell_action = Input.is_action_just_pressed('spell_action');
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	
	var mouse_direction = get_mouse_direction();
	
	if 'left' in mouse_direction:
		Player.orientation = 'left';
	elif 'right' in mouse_direction:
		Player.orientation = 'right';
	
	move_and_slide();
	handle_animations(tool_action, spell_action, direction);

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

	
func handle_animations(tool_action, spell_action, direction):
	if tool_action and not in_animation:
		aim_primary()
		var item := primary_hand.get_child(0);
		if item:
			match item.tool_type:
				Constants.tool_type.SWORD:
					swing_sword();
				Constants.tool_type.AXE:
					swing_axe();
				Constants.tool_type.HOE:
					swing_hoe();
		
	if spell_action && animation_player.animation_finished:
		var spell = Player.player_spellbar[str(Player.active_spell)];
		# handles the use case where the spell slot is empty
		if spell:
			spell = spell.duplicate(); # we need to duplicate to ensure its not the instance used for the inventory slot
		if Player.mana - spell.mana_cost < 0:
			return;
		take_mana(spell.mana_cost);
		match spell.cast_type:
			Constants.cast_type.SHOOT:
				spell.global_position = projetile_summon_point.global_position;
			Constants.cast_type.DROP:

				spell.global_position = get_global_mouse_position();
		get_parent().add_child(spell);
	
	if !tool_action && !spell_action:
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

# HurtBox helpers
func take_damage(damage: float):
	if Player.health - damage < 0:
		Player.health = 0;
	Player.health -= damage;

# apply mana consumption to Player
func take_mana(mana_cost: float):
	if Player.mana - mana_cost < 0:
		Player.mana = 0;
	Player.mana -= mana_cost;

func apply_debuff(debuff_object: Debuff):
	var debuff_hit_timer := Timer.new();
	add_child(debuff_hit_timer);
	debuff_hit_timer.wait_time = debuff_object.frequency;
	debuff_hit_timer.timeout.connect(func():
		take_damage(debuff_object.damage.pick_random());
	);
	debuff_hit_timer.start();
	await get_tree().create_timer(debuff_object.duration).timeout;
	debuff_hit_timer.queue_free();
	

func swing_axe():
	primary_pivot.visible = true;
	primary_hand.position.x = 0;
	if Player.orientation == 'left':
		pass
	else:
		pass;
		
	print(get_global_mouse_position);
	var cuttable_items = cursor.check_for_foliage();
	for item in cuttable_items:
		item.take_damage(20);
	primary_pivot.visible = false;

func swing_hoe():
	primary_pivot.visible = true;
	print('swinging hoe');
	primary_pivot.visible = false;

# performs animation for swinging swords (rotate around pivot)
func swing_sword():
	# offset x position for animation
	primary_hand.position.x = 12;
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
	if item_in_hand:
		item_in_hand.get_node('HitBox').disabled = true;
	in_animation = false;
	primary_pivot.visible = false;
