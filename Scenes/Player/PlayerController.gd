extends Node3D
class_name PlayerController

@export_category("Plugging In Nodes")

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


func _process(delta: float) -> void:
	#print(EnemyManager.enemies_in_play)
	facing_direction = -transform.basis.z
	
	var up_down = Input.get_axis("nose_up", "nose_down")
	var target_pitch_input = mouse_y_input
	var target_roll_input = mouse_x_input
	
	smoothed_pitch_input = lerp(smoothed_pitch_input, target_pitch_input, mouse_smoothing * delta)
	smoothed_roll_input = lerp(smoothed_roll_input, target_roll_input, mouse_smoothing * delta)
	
	if abs(smoothed_pitch_input) > 0.001:
		rotate_object_local(Vector3.RIGHT, smoothed_pitch_input * nose_rotation_speed * delta)
	
	if abs(smoothed_roll_input) > 0.001:
		rotate_object_local(Vector3.FORWARD, -smoothed_roll_input * roll_rotation_speed * delta)
	

	
	if Input.is_action_just_pressed("Brake"):
		original_velocity = velocity
	
	if Input.is_action_pressed("Brake"):
		throttle = 0.0
		velocity = lerp(original_velocity, Vector3.ZERO, current_brake/brake_timer)
		current_brake += delta
	
	if Input.is_action_just_released("Brake"):
		current_brake = 0
	
	mouse_x_input = 0.0
	mouse_y_input = 0.0
	
	if up_down != 0:
		throttle += up_down * throttle_change_rate * delta
	else:
		throttle = lerp(throttle, 0.0, delta)
	
	throttle = clampf(throttle, -throttle_max, throttle_max)
	var acceleration: Vector3 = facing_direction * throttle
	velocity += acceleration * delta
	velocity = velocity.limit_length(max_speed)
	position += velocity * delta
	# FireWeapons(delta)


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
	else:
		Globalhealthscript.damage_player(1000)
