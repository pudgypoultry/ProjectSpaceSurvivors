extends Node

var actorReference

func _ready():
	actorReference = get_parent().get_parent()

func Process(delta: float) -> void:
	#print(EnemyManager.enemies_in_play)
	
	var up_down = Input.get_axis("throttle_down", "throttle_up")
	var left_right = Input.get_axis("roll_right", "roll_left")
	
	#if abs(smoothed_pitch_input) > 0.001:
		#rotate_object_local(Vector3.RIGHT, smoothed_pitch_input * nose_rotation_speed * delta)
	#
	#if abs(smoothed_roll_input) > 0.001:
		#rotate_object_local(Vector3.FORWARD, -smoothed_roll_input * roll_rotation_speed * delta)
	
	if Input.is_action_just_pressed("grapple") && !actorReference.grappling:
		print("Grapplin...")
		var newGrapple = actorReference.grapplingHook.instantiate()
		var spawn_offset = -actorReference.transform.basis.z * 1.5
		get_tree().root.add_child(newGrapple)
		newGrapple.global_position = actorReference.global_position + spawn_offset
		newGrapple.global_position = actorReference.global_position

		newGrapple.add_collision_exception_with(self)
		# await get_tree().create_timer(1.0).timeout
		
		actorReference.currentGrapple = newGrapple
		actorReference.currentGrapple.Fire(-actorReference.transform.basis.z)
		actorReference.grappling = true
	
	elif Input.is_action_just_pressed("grapple") && actorReference.grappling:
		print("Done Grapplin")
		if is_instance_valid(actorReference.currentGrapple):
			actorReference.currentGrapple.Release()
		actorReference.grappling = false
	
	if Input.is_action_just_pressed("brake"):
		actorReference.original_velocity = actorReference.velocity
	
	if Input.is_action_pressed("brake"):
		actorReference.throttle = 0.0
		actorReference.velocity = lerp(actorReference.original_velocity, Vector3.ZERO, (actorReference.current_brake * actorReference.currentInertia)/actorReference.brake_timer)
		actorReference.current_brake += delta
		if actorReference.current_brake * actorReference.currentInertia / actorReference.brake_timer > 1.0:
			actorReference.velocity = Vector3.ZERO
	
	if Input.is_action_just_released("brake"):
		actorReference.current_brake = 0
	
	#mouse_x_input = 0.0
	#mouse_y_input = 0.0
	
	if up_down != 0:
		actorReference.throttle += up_down * actorReference.throttle_change_rate * delta
	else:
		actorReference.throttle = lerp(actorReference.throttle, 0.0, delta)
	
	if left_right != 0:
		actorReference.basis = actorReference.basis.rotated(actorReference.basis.z, left_right * 0.05)
	
	actorReference.throttle = clampf(actorReference.throttle, -actorReference.throttle_max, actorReference.throttle_max)
	actorReference.thrusterHolder.thrust = actorReference.throttle
	#var acceleration: Vector3 = facing_direction * throttle
	#velocity += acceleration * delta
	#velocity = velocity.limit_length(max_speed)
	#position += velocity * delta
	# FireWeapons(delta)


func PhysicsProcess(delta: float) -> void:
	var target_pitch_input = actorReference.mouse_y_input
	var target_roll_input = actorReference.mouse_x_input
	actorReference.facing_direction = -actorReference.transform.basis.z
	
	actorReference.smoothed_pitch_input = lerp(actorReference.smoothed_pitch_input, target_pitch_input, actorReference.mouse_smoothing * delta)
	actorReference.smoothed_roll_input = lerp(actorReference.smoothed_roll_input, target_roll_input, actorReference.mouse_smoothing * delta)
	
	if abs(actorReference.smoothed_pitch_input) > 0.001:
		actorReference.rotate_object_local(Vector3.RIGHT, actorReference.smoothed_pitch_input * actorReference.nose_rotation_speed * delta)
	
	if abs(actorReference.smoothed_roll_input) > 0.001:
		actorReference.rotate_object_local(Vector3.DOWN, -actorReference.smoothed_roll_input * actorReference.roll_rotation_speed * delta)
	
	actorReference.mouse_x_input = 0.0
	actorReference.mouse_y_input = 0.0
	
	actorReference.apply_central_force(-actorReference.transform.basis.z * actorReference.throttle)
