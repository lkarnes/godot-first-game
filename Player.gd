extends CharacterBody2D

const SPEED = 600;

func _physics_process(delta):
	if !Player.player:
		Player.player = self;
	
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down");
	velocity = direction * SPEED;
	move_and_slide();
		
