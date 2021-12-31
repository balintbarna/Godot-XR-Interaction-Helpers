extends SpatialManipulator
class_name ArvrBodyManipulator


export(NodePath) var origin_path
onready var origin_node = get_node(origin_path) as ArvrOriginWithReferences
func _ready():
    if not origin_node is ArvrOriginWithReferences:
        push_error("ArvrOriginWithReferences is not at path")


func get_right_hand():
    return get_origin().right


func get_left_hand():
    return get_origin().left


func get_head():
    return get_origin().hmd


func get_origin():
    return origin_node
