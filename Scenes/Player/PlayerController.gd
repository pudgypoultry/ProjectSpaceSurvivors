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
@export var max_speed : float = 5 # This variable is now used
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

var equipped_weapons = [PlayerEquipment]
var equipped_passives = [PlayerEquipment]


func _ready():
	StatManager.StartGame(self)
	currentHealth = baseHealth
	currentArmor = baseArmor
	currentSpeed = baseSpeed
	currentInertia = baseInertia
	currentExperience = baseExperience
	currentRepair = baseRepair
	currentPickupRange = basePickupRange


func _process(delta: float) -> void:
	#print(EnemyManager.enemies_in_play)
	
	var up_down = Input.get_axis("throttle_down", "throttle_up")
	
	
	#if abs(smoothed_pitch_input) > 0.001:
		#rotate_object_local(Vector3.RIGHT, smoothed_pitch_input * nose_rotation_speed * delta)
	#
	#if abs(smoothed_roll_input) > 0.001:
		#rotate_object_local(Vector3.FORWARD, -smoothed_roll_input * roll_rotation_speed * delta)
	
	if Input.is_action_just_pressed("grapple") && !grappling:
		print("Grapplin...")
		var newGrapple = grapplingHook.instantiate()
		var spawn_offset = -transform.basis.z * 1.5
		get_tree().root.add_child(newGrapple)
		newGrapple.global_position = global_position + spawn_offset
		newGrapple.global_position = global_position

		newGrapple.add_collision_exception_with(self)
		# await get_tree().create_timer(1.0).timeout
		
		currentGrapple = newGrapple
		currentGrapple.Fire(-transform.basis.z)
		grappling = true
	
	elif Input.is_action_just_pressed("grapple") && grappling:
		print("Done Grapplin")
		if is_instance_valid(currentGrapple):
			currentGrapple.Release()
		grappling = false
	
	if Input.is_action_just_pressed("brake"):
		original_velocity = velocity
	
	if Input.is_action_pressed("brake"):
		throttle = 0.0
		velocity = lerp(original_velocity, Vector3.ZERO, (current_brake * currentInertia)/brake_timer)
		current_brake += delta
		if current_brake * currentInertia / brake_timer > 1.0:
			velocity = Vector3.ZERO
	
	if Input.is_action_just_released("brake"):
		current_brake = 0
	
	#mouse_x_input = 0.0
	#mouse_y_input = 0.0
	
	if up_down != 0:
		throttle += up_down * throttle_change_rate * delta
	else:
		throttle = lerp(throttle, 0.0, delta)
	
	throttle = clampf(throttle, -throttle_max, throttle_max)
	thrusterHolder.thrust = throttle
	#var acceleration: Vector3 = facing_direction * throttle
	#velocity += acceleration * delta
	#velocity = velocity.limit_length(max_speed)
	#position += velocity * delta
	# FireWeapons(delta)


func _physics_process(delta: float) -> void:
	var target_pitch_input = mouse_y_input
	var target_roll_input = mouse_x_input
	facing_direction = -transform.basis.z
	
	smoothed_pitch_input = lerp(smoothed_pitch_input, target_pitch_input, mouse_smoothing * delta)
	smoothed_roll_input = lerp(smoothed_roll_input, target_roll_input, mouse_smoothing * delta)
	
	if abs(smoothed_pitch_input) > 0.001:
		rotate_object_local(Vector3.RIGHT, smoothed_pitch_input * nose_rotation_speed * delta)
	
	if abs(smoothed_roll_input) > 0.001:
		rotate_object_local(Vector3.FORWARD, -smoothed_roll_input * roll_rotation_speed * delta)
	
	mouse_x_input = 0.0
	mouse_y_input = 0.0
	
	apply_central_force(-transform.basis.z * throttle)
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
		mouse_y_input = -mouse_motion_event.relative.y * mouse_sensitivity
		mouse_x_input = -mouse_motion_event.relative.x * mouse_sensitivity

func EquipWeapon(newWeapon : Node3D):
	print(newWeapon)
	equipped_weapons.append(newWeapon)
	newWeapon.position = Vector3.ZERO
	newWeapon.rotation = rotation
	add_child(newWeapon)

func EquipPassive(newPassive : Node3D):
	print(newPassive)
	equipped_passives.append(newPassive)
	add_child(newPassive)

func ReaggregateStats():
	for weapon in equipped_weapons:
		weapon.currentDamage *= StatManager.aggregation["damage"]
		weapon.currentDuration *= StatManager.aggregation["duration"]
		weapon.currentCooldown *= StatManager.aggregation["cooldown"]
		weapon.currentArea *= StatManager.aggregation["area"]
		weapon.currentProjectileSpeed *= StatManager.aggregation["projectileSpeed"]
		weapon.currentProjectileAmount *= StatManager.aggregation["projectileAmount"]

	for passive in equipped_passives:
		pass


func _on_body_3d_body_entered(body: Node) -> void:
	if body.is_in_group("Enemies"):
		Globalhealthscript.damage_player(body.damage)
	elif body.is_in_group("Grappleable"):
		print("CRASHED")
		Globalhealthscript.damage_player(1000)
