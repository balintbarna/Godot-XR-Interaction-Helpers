extends Spatial
class_name SpatialManipulator


onready var spatial_parent = get_parent() as Spatial
func _ready():
    if not spatial_parent is Spatial:
        push_error("SpatialManipulator parent is not Spatial")