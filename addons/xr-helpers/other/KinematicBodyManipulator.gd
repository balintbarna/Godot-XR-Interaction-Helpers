extends Spatial
class_name KinematicBodyManipulator


onready var kinematic_body = get_parent() as KinematicBody
func _ready():
    if not kinematic_body is KinematicBody:
        push_error("KinematicBodyManipulator parent is not KinematicBody")
