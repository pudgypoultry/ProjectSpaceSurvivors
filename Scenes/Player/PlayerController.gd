class_name PlayerController

extends RigidBody3D


@export_category("Plugging In Nodes")
@export var grapplingHook : PackedScene
@export var thrusterHolder : Node3D
var grappling = false
var currentGrapple : GrapplingHook

@export_category("Starting Stats")
@export var baseHealth : float = 100.0
@export var baseArmor : float = 0.0
@export var baseSpeed : float = 1.0
@export var baseInertia : float = 1.0
@export var baseExperience : float = 1.0
@export var baseRepair : float = 1.0
@export var basePickupRange : float = 1.0

var currentHealth
var currentArmor
var currentSpeed
var currentInertia
var currentExperience
var currentRepair
var currentPickupRange

@export_category("Game Rules")
@export var throttle : float = 1.0
@export var throttle_change_rate : float = 1.0
@export var throttle_min : float = 0.0
@export var throttle_max : float = 1.0
@export var max_speed : float = 5
@export var player_health : float = 100.0
@export var nose_rotation_speed : float = 1.0
@export var roll_rotation_speed : float = 1.0
@export var modify_fire_rate : float = 1.0
@export var modify_damage : float = 1.0

@export_category("Mouse Controls")
@export var mouse_sensitivity : float = 0.5
@export var mouse_smoothing : float = 15.0 

@export_category("Plugging In Nodes")
@export var weaponFolder : Node3D
@export var passiveFolder : Node3D
@export var currentCamera : Camera3D
@export var starFoxCamera : Camera3D
@export var allRangeCamera : Camera3D
@export var stateManager : Node
@export var currentState : Node

var mouse_x_input: float = 0.0
var mouse_y_input: float = 0.0
var smoothed_pitch_input: float = 0.0
var smoothed_roll_input: float = 0.0
var brake_timer = 2.0
var current_brake = 0.0

var facing_direction : Vector3
var canAct : bool = true

var velocity: Vector3 = Vector3.ZERO # Replaces movement_direction
var original_velocity

var equipped_weapons : Array[EquipmentWeapon] = []
var equipped_passives : Array[EquipmentPassive] = []


func _ready():
	StatManager.StartGame(self)
	EnemyManager.player_ship = self
	currentHealth = baseHealth
	currentArmor = baseArmor
	currentSpeed = baseSpeed
	currentInertia = baseInertia
	currentExperience = baseExperience
	currentRepair = baseRepair
	currentPickupRange = basePickupRange


func _process(delta: float) -> void:
	currentState.Process(delta)


func _physics_process(delta: float) -> void:
	currentState.PhysicsProcess(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
		mouse_y_input = -mouse_motion_event.relative.y * mouse_sensitivity
		mouse_x_input = -mouse_motion_event.relative.x * mouse_sensitivity


func SwapMode(mode : StateManager.State):
	match mode:
		StateManager.State.STARFOX:
			currentCamera = starFoxCamera
			currentState = stateManager.GetState(StateManager.State.STARFOX)
			print("I AM NOW IN STARFOX MODE")
		StateManager.State.ALLRANGE:
			currentCamera = allRangeCamera
			currentState = stateManager.GetState(StateManager.State.ALLRANGE)
			print("I AM NOW IN ALLRANGE MODE")
	currentCamera.current = true


func EquipWeapon(newWeapon : Node3D):
	print(newWeapon)
	equipped_weapons.append(newWeapon)
	newWeapon.position = Vector3.ZERO
	newWeapon.rotation = rotation
	weaponFolder.add_child(newWeapon)


func RemoveWeapon(weaponToRemove : Node3D):
	if weaponToRemove in equipped_weapons:
		print("Removing Weapon:	", str(weaponToRemove))
		equipped_weapons.erase(weaponToRemove)
		weaponToRemove.queue_free()
	else:
		print("Hey dingus the weapon's not here")


func RemovePassive(passiveToRemove : Node3D):
	if passiveToRemove in equipped_passives:
		print("Removing Passive:	", str(passiveToRemove))
		equipped_passives.erase(passiveToRemove)
		passiveToRemove.queue_free()
	else:
		print("Hey dingus the passive's not here")


func EquipPassive(newPassive : Node3D):
	print(newPassive)
	equipped_passives.append(newPassive)
	newPassive.position = Vector3.ZERO
	newPassive.rotation = rotation
	equipped_passives.append(newPassive)
	passiveFolder.add_child(newPassive)


func ReaggregateStats():
	print("EQUIPPED WEAPONS:	" + str(equipped_weapons))
	if len(equipped_weapons) > 0:
		print(equipped_weapons[0].currentDamage)
	for weapon : EquipmentWeapon in equipped_weapons:
		weapon.currentDamage *= StatManager.aggregation["damage"]
		weapon.currentDuration *= StatManager.aggregation["duration"]
		weapon.currentCooldown *= StatManager.aggregation["cooldown"]
		weapon.currentArea *= StatManager.aggregation["area"]
		weapon.currentProjectileSpeed *= StatManager.aggregation["projectileSpeed"]
		weapon.currentProjectileAmount *= StatManager.aggregation["projectileAmount"]
		print(weapon.name + "'s current damage is:	" + str(weapon.currentDamage))
	for passive in equipped_passives:
		pass


func _on_body_3d_body_entered(body: Node) -> void:
	if body.is_in_group("Enemies"):
		Globalhealthscript.damage_player(body.damage)
	elif body.is_in_group("Grappleable"):
		print("CRASHED")
		Globalhealthscript.damage_player(1000)
