extends Node


signal new_mapping_set


const MOUSE_ROTATION_MULTIPLIER = 10
var mouse_motion_buffer = Vector2()
var vr_origin: ARVROrigin
var left_vr_controller: ARVRController
var right_vr_controller: ARVRController
var mapping = BaseMapping.new() setget set_mapping, get_mapping
func set_mapping(value):
    mapping = value
    emit_signal("new_mapping_set")
func get_mapping():
    return mapping


func _init():
    vr_origin = ARVROrigin.new()
    left_vr_controller = ARVRController.new()
    left_vr_controller.controller_id = 1
    vr_origin.add_child(left_vr_controller)
    right_vr_controller = ARVRController.new()
    right_vr_controller.controller_id = 2
    vr_origin.add_child(right_vr_controller)
    add_child(vr_origin)


func _physics_process(_delta):
    handle_mouse_capture()
    create_rotation_action()
    create_move_action()


func create_move_action():
    if is_arvr():
        var leftright = left_vr_controller.get_joystick_axis(mapping.STICK_X) # [-1; 1]
        var backforward = left_vr_controller.get_joystick_axis(mapping.STICK_Y) # [-1; 1]
        var vector = Vector2(leftright, backforward) # (X, Y)
        set_vector("movement_left", "movement_right", "movement_back", "movement_forward", vector)


func create_rotation_action():
    var yaw = 0
    if is_arvr():
        yaw = right_vr_controller.get_joystick_axis(mapping.STICK_X)
    else:
        var vp_size = get_viewport().size
        yaw = MOUSE_ROTATION_MULTIPLIER * mouse_motion_buffer.x / vp_size.x
        var pitch = MOUSE_ROTATION_MULTIPLIER * mouse_motion_buffer.y / vp_size.y
        mouse_motion_buffer = Vector2()
        set_axis("pitch_up", "pitch_down", pitch)
    set_axis("yaw_left", "yaw_right", yaw)


func handle_mouse_capture():
    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _input(event):
    if is_rotate_event(event):
        mouse_motion_buffer += event.relative


func is_rotate_event(event):
    return (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED) or event is InputEventScreenDrag


func is_arvr():
    return true if ARVRServer.primary_interface else false


func set_axis(negative_action: String, positive_action: String, value: float):
    # warning-ignore:STANDALONE_TERNARY
    Input.action_press(negative_action, -value) if value < 0 else Input.action_release(negative_action)
    # warning-ignore:STANDALONE_TERNARY
    Input.action_press(positive_action, value) if value > 0 else Input.action_release(positive_action)


func set_vector(negative_x: String, positive_x: String, negative_y: String, positive_y: String, vector: Vector2):
    set_axis(negative_x, positive_x, vector.x)
    set_axis(negative_y, positive_y, vector.y)
