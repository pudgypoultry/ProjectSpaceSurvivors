extends Node3D

var frequency:float = 70
	
func _physics_process(delta: float) -> void:
	self.rotation.y += delta * frequency * PI / 180


func _on_rigid_body_3d_body_entered(body: Node) -> void:
	body.get_parent().destroyed.emit()
