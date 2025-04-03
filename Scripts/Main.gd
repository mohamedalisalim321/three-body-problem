extends Node2D

var celestial_bodies = []
var starting_points = [
	Vector2(270.5, 128),
	Vector2(64, 128),
	Vector2(168, 48),
]

@onready var celestial_node_path: Node2D = $CelestialBodies

func _ready() -> void:
	for i in celestial_node_path.get_children():
		celestial_bodies.append(i)
		starting_points.append(i.position)

func _physics_process(delta: float) -> void:
	#print(Engine.get_frames_per_second())
	
	if Input.is_action_just_pressed("space"):
		_restart()
	
	for body in celestial_bodies:
		var net_force = Vector2.ZERO
		
		for other_body in celestial_bodies:
				if body != other_body:
					var direction = (other_body.position - body.position) as Vector2
					var distance = direction.length()
					if distance < 5:
						continue
					
					var force_mag = (Globals.G * body.mass * other_body.mass) / (distance * distance)
					
					var force = direction.normalized() * force_mag
					net_force += force
		
		var acceleration = net_force / body.mass
		body.current_velocity += acceleration * delta

func _restart():
	var n = 0
	for i in celestial_bodies:
		n += 1
		i._clear_points()
		i.position = starting_points[n ]
