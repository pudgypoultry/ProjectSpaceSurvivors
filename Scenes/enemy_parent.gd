extends Node
class_name Enemy

# signals
signal died

# export for balancing
@export_group("Stats")
@export var max_health: float = 30.0
@export var speed: float = 5.0

# stats
var current_health: float
var is_dead: bool = false
var weapon = Node
var behavior = Node
# enemies have health, speed, weapon they have, movement behavior

func _ready():
	current_health = max_health
	died.connect(dying)
	initialize()

# for special characteristics of non-base class
func initialize():
	pass
	
func _physics_process(delta):
	if is_dead:
		return
		
func dying():
	is_dead = true
	died.emit()
	print("Died!")
		
func take_damage(dmg: float):
	current_health -= dmg
	if current_health <= 0:
		dying()
