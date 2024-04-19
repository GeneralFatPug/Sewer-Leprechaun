extends Area2D

@export var speed = 150

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	global_position.y += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if(body.is_in_group("Player")):
		body.handle_collision("BOMB")
		queue_free()
	
