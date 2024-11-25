extends Node2D

@export var world_speed = 300

@onready var moving_environment = $"/root/World/Environment/Moving"

var platform = preload("res://scenes/platform.tscn")
var rng = RandomNumberGenerator.new()
var last_platform_position = Vector2.ZERO
var next_spawn_time = 0

func _ready() -> void:
	rng.randomize()


func _process(delta: float) -> void:
	# Spawn new platform
	if Time.get_ticks_msec() > next_spawn_time:
		var new_platform = platform.instantiate()
		
		# Set position of new platform
		if last_platform_position == Vector2.ZERO:
			new_platform.position = Vector2(400, 0)
		else:
			var x = last_platform_position.x + rng.randi_range(450, 550)
			var y = clamp(last_platform_position.y + rng.randi_range(-150, 150), 200, 1000)
			new_platform.position = Vector2(x, y)
		
		# Add the platform to the moving environment
		moving_environment.add_child(new_platform)
		
		# Update the last platform position and increase the next spawn time
		last_platform_position = new_platform.position
		next_spawn_time += world_speed

func _physics_process(delta: float) -> void:
	# Move the platforms left
	moving_environment.position.x -= world_speed * delta
