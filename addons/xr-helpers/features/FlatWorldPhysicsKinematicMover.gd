extends KinematicBodyManipulator
class_name FlatWorldPhysicsKinematicMover


const SNAP_VECTOR = Vector3(0, -1, 0)
const UP_DIRECTION = Vector3(0, 1, 0)
const STOP_ON_SLOPE = true
const MAX_SLIDES = 4
const FLOOR_MAX_ANGLE = 0.785398
const INFINITE_INERTIA = false


export var GRAVITY_ACCELERATION_MPS2 = 9.81
export var NORMAL_ACCELERATION_MPS2 = 9
export var SPRINT_ACCELERATION_MPS2 = 15
export var NORMAL_MAX_SPEED_MPS = 3
export var SPRINT_MAX_SPEED_MPS = 5
export var CUTOFF_VELOCITY_MPS = 0.02
export var DAMPING_COEFFICIENT_GROUND_NSPM = 1
export var DAMPING_COEFFICIENT_AIR_NSPM = 9
export var JUMP_SPEED_MPS = 50 # overrides vertical speed
export var MASS_KG = 70
var max_speed = NORMAL_MAX_SPEED_MPS
var max_acceleration = NORMAL_ACCELERATION_MPS2
var velocity = Vector3()


func _physics_process(delta: float):
    apply_movement(delta)


func apply_movement(delta: float) -> void:
    calculate_sprint()
    apply_dampening(delta)
    velocity.y -= GRAVITY_ACCELERATION_MPS2 * delta # apply gravity
    accelerate_from_inputs(delta)
    velocity = kinematic_body.move_and_slide_with_snap(velocity, SNAP_VECTOR, UP_DIRECTION, STOP_ON_SLOPE, MAX_SLIDES, FLOOR_MAX_ANGLE, INFINITE_INERTIA)


func accelerate_from_inputs(delta: float) -> void:
    if kinematic_body.is_on_floor():
        var input_vector = get_velocity_input_vector()
        input_vector.y = 0
        if input_vector.length() > 1:
            input_vector = input_vector.normalized()
        var target_velocity = input_vector * max_speed
        var vertical = velocity.y
        velocity.y = 0
        var ideal_dv = target_velocity - velocity
        velocity.y = vertical
        var max_dv = max_acceleration * delta
        if ideal_dv.length() < max_dv:
            velocity = target_velocity
        else:
            var dv = ideal_dv.normalized() * max_dv
            velocity += dv
        if Input.is_action_pressed("movement_jump"):
            velocity.y = JUMP_SPEED_MPS


func apply_dampening(delta: float) -> void:
    if velocity.length() > CUTOFF_VELOCITY_MPS:
        var coeffs = DAMPING_COEFFICIENT_AIR_NSPM + (DAMPING_COEFFICIENT_GROUND_NSPM if kinematic_body.is_on_floor() else 0)
        # F = c*v
        # F = m*a -> a = F/m
        # dV = a*delta
        var damping_ratio = coeffs * delta / MASS_KG
        if damping_ratio < 1:
            velocity *= (1 - damping_ratio)
        else:
            velocity = Vector3()


func calculate_sprint() -> void:
    var sprint = 1 if Input.is_action_pressed("movement_sprint") else 0 # TODO add VR sprinting capability by hand movement
    max_speed = NORMAL_MAX_SPEED_MPS + sprint * (SPRINT_MAX_SPEED_MPS - NORMAL_MAX_SPEED_MPS)
    max_acceleration = NORMAL_ACCELERATION_MPS2 + sprint * (SPRINT_ACCELERATION_MPS2 - NORMAL_ACCELERATION_MPS2)


func get_velocity_input_vector() -> Vector3:
    return get_forward_velocity_input_vector() + get_rightward_velocity_input_vector()


func get_forward_velocity_input_vector() -> Vector3:
    return -self.global_transform.basis.z * Input.get_axis("movement_back", "movement_forward")


func get_rightward_velocity_input_vector() -> Vector3:
    return self.global_transform.basis.x * Input.get_axis("movement_left", "movement_right")
