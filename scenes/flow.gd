extends CharacterBody2D

@export var velocidade: float = 110.0
@export var distancia_minima: float = 16.0
@export var gravidade: float = 980.0

@onready var sprite: AnimatedSprite2D = $spriteLenhador

var protagonista: CharacterBody2D = null
var atacando: bool = false

func _ready() -> void:
	_achar_protagonista()

func _achar_protagonista() -> void:
	var cena_atual := get_tree().current_scene
	if cena_atual == null:
		return

	var por_nome := cena_atual.find_child("protagonista", true, false)
	if por_nome is CharacterBody2D:
		protagonista = por_nome

func _physics_process(delta: float) -> void:
	# Gravidade no eixo Y
	if not is_on_floor():
		velocity.y += gravidade * delta
	elif velocity.y > 0.0:
		velocity.y = 0.0

	# Garante a referência do protagonista
	if not is_instance_valid(protagonista):
		_achar_protagonista()

	# Perseguição horizontal
	if not atacando and is_instance_valid(protagonista):
		var dx := protagonista.global_position.x - global_position.x
		if abs(dx) > distancia_minima:
			var direcao_x: float = sign(dx)
			velocity.x = direcao_x * velocidade
			if sprite != null:
				sprite.flip_h = direcao_x < 0.0
		else:
			velocity.x = move_toward(velocity.x, 0.0, velocidade)
	elif atacando:
		velocity.x = 0.0
	else:
		velocity.x = 0.0

	_atualizar_animacao()
	move_and_slide()

func _atualizar_animacao() -> void:
	if sprite == null or atacando:
		return

	# Troque "andar" e "parado" pelos nomes exatos das animações no seu AnimatedSprite2D
	if abs(velocity.x) > 5.0 and sprite.sprite_frames != null and sprite.sprite_frames.has_animation("andar"):
		if sprite.animation != "andar":
			sprite.play("andar")
	elif sprite.sprite_frames != null and sprite.sprite_frames.has_animation("parado"):
		if sprite.animation != "parado":
			sprite.play("parado")

func _on_area_2d_area_entered(_area: Area2D) -> void:
	$spriteLenhador.play("atingido")


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	$spriteLenhador.play('atingido')
