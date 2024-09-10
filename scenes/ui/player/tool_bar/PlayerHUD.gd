extends ReferenceRect


func _physics_process(delta):
	%ManaBar.value = Player.mana;
	%HealthBar.value = Player.health;
