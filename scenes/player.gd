extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_force: float = 600.0
@export var gravity: float = 1500.0

func _physics_process(delta):
	# -------------------------
	# MOVIMENTO HORIZONTAL
	# -------------------------
	var direction = Input.get_axis("esquerda", "direita")

	velocity.x = direction * speed


	# -------------------------
	# GRAVIDADE
	# -------------------------
	if not is_on_floor():
		velocity.y += gravity * delta


	# -------------------------
	# PULO
	# -------------------------
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = -jump_force


	# -------------------------
	# MOVIMENTO
	# -------------------------
	move_and_slide()


	# -------------------------
	# ANIMAÇÕES
	# -------------------------
	if not is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")

	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")

	else:
		$AnimatedSprite2D.play("idle")


	# -------------------------
	# DIREÇÃO DO PERSONAGEM
	# -------------------------
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true

	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
