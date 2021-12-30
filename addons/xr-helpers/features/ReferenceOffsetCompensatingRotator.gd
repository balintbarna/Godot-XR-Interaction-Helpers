extends SpatialManipulator
class_name ReferenceOffsetCompensatingRotator


export var ROTATION_SPEED_RPS = 2*PI


func _physics_process(delta: float):
    rotate_base_and_compensate_reference_offset(delta, spatial_parent, self)


func rotate_base_and_compensate_reference_offset(delta: float, base: Spatial, reference: Spatial) -> void:
    if not base or not reference:
        push_error("Missing base or reference in offset correcting rotator")
        return
    var offset_from_rotation = apply_rotation_and_calculate_offset(delta, base, reference)
    base.global_translate(-offset_from_rotation)


func apply_rotation_and_calculate_offset(delta: float, base: Spatial, reference: Spatial) -> Vector3:
    var old = reference.global_transform.origin
    apply_rotation(delta, base)
    var new = reference.global_transform.origin
    return new - old


func apply_rotation(delta: float, base: Spatial) -> void:
    base.rotate_y(get_player_rotation_amount(delta))


func get_player_rotation_amount(delta: float) -> float:
    return Input.get_axis("yaw_right", "yaw_left") * delta * ROTATION_SPEED_RPS
