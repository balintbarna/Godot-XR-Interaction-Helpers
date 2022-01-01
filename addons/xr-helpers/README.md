# Plug-and-Play XR features

This addon contains helper classes and example scenes for common XR related challenges. Currently it supports movement with or without collisions and physics, rotation of player around camera, setting orientation intuitively based on a combination of head orientation and hands position. Future version will add grab, touch, climbing, space physics, etc.

## Setup

Dependencies:
- Extra Math for GDScript
- some kind of VR runtime, such as OpenXR

Ensure that the `InputMapper` script in the autoload folder has been activated in the project settings as an AutoLoad

Check the *examples* folder for inspiration on how to use the scripts in this addon to build your VR scene.

## Feature Nodes

`ReferenceOffsetCompensatingRotator`
- Rotates parent node
- Uses its own position as reference (use with RemoteTransform)
- Offsets parents based on its own global displacement resulting from the rotation
- This is useful for rotating the character *without moving the HMD camera*

`FreeLookMover`
- A feature node that moves its *Spatial* parent
  - Based on input actions
  - According to its own orientation
- It can be used as a free look feature.

`FlatWorldPhysicsKinematicMover`
- Moves its parent kinematic body
  - Based on input actions
  - According to its own orientation
- Uses collisions
- Has many exported physics properties for the pretense of some realistic physics based movement
- Has gravity
- Great for normal character movement

`TripleMethodOrientationGuesser`
- Sets parent's forward direction
  - Uses VR HMD orientation, only if it is upright
  - Uses global position of VR controllers compared to its own
  - Uses the relative position of the left-right controllers to each other
- The goal of this feature is to provide an intuitive way to guess the rotation of the physical player based on their head and hands poses

`VrFrameHeightScaler`
- Calculates its relative altitude in the VR Origin frame
- Sets the height property on the parent
- Useful to set height on a collision shape based on the real-world altitude of the VR HMD

### Other Classes

`ArvrOriginWithReferences`
- extends ARVROrigin to hold references for the HMD and the controllers
- automatically finds them in the ready call among its children
- Properties:
  - `hmd: ARVRCamera`
  - `left: ARVRController`
  - `right: ARVRController`

`BaseMapping`
- holds the common VR controller button and axis values
- values which differ by runtime are variables instead of constants
- those variables are `-1` by default and the extending class can override them

`InputMapper`
- AutoLoad class
- Sets action values for movement based on left controller joystick: `movement_left`, `movement_right`, `movement_back`, `movement_forward`
- Sets yaw rotation actions based on right controller joystick: `yaw_left`, `yaw_right`
- Sets yaw and pitch rotation actions based on mouse movement: `pitch_up`, `pitch_down`
- Handles mouse capture with the ESC key (`ui_cancel`)
- You have to create these actions in the project settings input map, you can also map WASD to the movement actions so your character can be moved around with mouse and keyboard for debugging purposes. Console controllers can also be mapped to these actions to support all input devices.

`SpatialManipulator`, `KinematicBodyManipulator`
- Base classes for features that manipulate a certain type of parent node

`ArvrManipulator`
- Extends *SpatialManipulator*
- Base class for features that require reference to the ARVR nodes
- Node path to VR rigin must be set
- Comes with convenience functions:
  - `get_origin()`
  - `get_head()`
  - `get_left_hand()`
  - `get_right_hand()`
