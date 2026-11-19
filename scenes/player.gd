extends CharacterBody2D

@export var speed: float = 400.0
@export var jump_force: float = 600.0
@export var gravity: float = 1500.0

@onready var invulnerability_timer: Timer = $InvulnerabilityTimer


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
			$AnimatedPlayer2D.play("jump")
		else:
			$AnimatedPlayer2D.play("fall")

	elif velocity.x != 0:
		$AnimatedPlayer2D.play("walk")

	else:
		$AnimatedPlayer2D.play("idle")


	# -------------------------
	# DIREÇÃO DO PERSONAGEM
	# -------------------------
	if velocity.x < 0:
		$AnimatedPlayer2D.flip_h = true

	elif velocity.x > 0:
		$AnimatedPlayer2D.flip_h = false

# --------------------------
# VIDA DO PERSONAGEM
#---------------------------

@export var vida_maxima: int = 3

var vida_atual: int

var invulneravel: bool = false


var morto: bool = false

# Sinais para comunicar alterações de vida a outros nós.
signal vida_alterada(vida_atual: int, vida_maxima: int)
signal personagem_morreu

func _ready() -> void:
	vida_atual = vida_maxima
	vida_alterada.emit(vida_atual, vida_maxima)
	$DamageTimer.start()
	
func receber_dano(quantidade: int = 1) -> void:
	if not invulneravel:
		vida_atual -= quantidade
		if vida_atual <= 0:
			personagem_morreu.emit() 
		else:
			invulneravel = true
			$AnimatedShield2D2.visible = true
			$AnimatedShield2D2.play("default")
			invulnerability_timer.start()
			
func _on_invulnerability_timer_timeout() -> void:
	$AnimatedShield2D2.visible = false
	$AnimatedShield2D2.stop()


func _on_damage_timer_timeout() -> void:
	receber_dano()
