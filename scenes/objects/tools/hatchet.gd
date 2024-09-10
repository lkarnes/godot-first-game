extends Area2D
@onready var sprite: Sprite2D = %Sprite2D
@export var flipped_texture: CompressedTexture2D;
@export var texture: CompressedTexture2D;
var type: Enums.hit_type = Enums.hit_type.DAMAGE;

func _physics_process(delta):
	if Player.orientation == 'right':
		scale = Vector2(1,1);
	else:
		scale = Vector2(1,1);
