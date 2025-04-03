extends RigidBody2D
class_name Celestial

@export var radius : float = 10.0
@export var color : Color = Color.BLUE
@export var initial_velocity = Vector2()

var current_velocity = Vector2()

@onready var line = $Line2D

func _ready() -> void:
	current_velocity = initial_velocity
	line.clear_points()
	line.default_color = color
	#radius *= 4.0
	$CollisionShape2D.scale *= radius
	$Sprite2D.modulate = color
	$Sprite2D.scale = Vector2(radius, radius)

func _process(delta: float) -> void:
	line.add_point(position)
	position += current_velocity * delta

func _clear_points():
	current_velocity = Vector2.ZERO
	line.clear_points()
