extends ARVROrigin
class_name ArvrOriginWithReferences


var hmd: ARVRCamera
var left: ARVRController
var right: ARVRController


func _ready():
    for i in range(get_child_count()):
        var child = get_child(i)
        if child is ARVRCamera:
            hmd = child
        elif child is ARVRController:
            match child.controller_id:
                1:
                    left = child
                2:
                    right = child
    if not hmd:
        push_warning("HMD node not found")
    if not left:
        push_warning("Left controller node not found")
    if not right:
        push_warning("Right controller node not found")
