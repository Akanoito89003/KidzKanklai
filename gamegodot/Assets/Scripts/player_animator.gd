extends Node2D

@export var player_controller : PlayerController
@export var animattion_player : AnimationPlayer
@export var sprite : Sprite2D

func _process(delta):
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
	
	if abs(player_controller.velocity.x) > 0.0:
		animattion_player.play("move")
	else:
		animattion_player.play("idle")
	
	if player_controller.velocity.y < 0.0:
		animattion_player.play("jump")
	elif player_controller.velocity.y > 0.0:
		animattion_player.play("fall")
