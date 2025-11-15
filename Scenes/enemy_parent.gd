extends Node
class_name EnemyParent

# signals
signal died
died.connect()
# maybe signal what enemy type died, maybe don't have to

# export for balancing
@export_group("Stats")
@export var max_health: float = 30.0
@export var speed: float = 5.0

# stats
var current_health: float
var is_dead: bool = false
var weapon = null
var behavior = null
# enemies have health, speed, weapon they have, movement behavior

func _ready():
	current_heatlh = max_health
	initialize()

# for special characteristics of non-base class
func initialize():
	pass
	
func _physics_process(delta):
	if is_dead:
		return
	
		
func died():
	
		
	
	
	
	
