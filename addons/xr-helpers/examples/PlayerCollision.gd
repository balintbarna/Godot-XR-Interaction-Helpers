extends CollisionShape


var height setget set_height, get_height

func set_height(value):
    height = value
    if shape is CapsuleShape:
        # Value equals the physical world height of the HMD
        # and the shape total height should be value + radius
        # to attempt to include the top of the player head
        # in the collision shape. Total height equals
        # shape height + 2 * radius.
        # warning-ignore:UNSAFE_PROPERTY_ACCESS
        # warning-ignore:UNSAFE_PROPERTY_ACCESS
        shape.height = value - shape.radius
        # The shape parent has the same transform as the VR origin
        # therefore setting the local transform Y coordinate to half
        # of the total height of the shape will put its lowest point
        # in the same real-world height as the physical floor.
        # warning-ignore:UNSAFE_PROPERTY_ACCESS
        # warning-ignore:UNSAFE_PROPERTY_ACCESS
        translation.y = shape.height / 2.0 + shape.radius
    else:
        push_error("WRONG SHAPE")

func get_height():
    if shape is CapsuleShape:
        # warning-ignore:UNSAFE_PROPERTY_ACCESS
        # warning-ignore:UNSAFE_PROPERTY_ACCESS
        return shape.height + shape.radius
    else:
        push_error("WRONG SHAPE")