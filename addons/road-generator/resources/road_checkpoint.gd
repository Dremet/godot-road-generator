@tool
extends Area3D
class_name RoadCheckpoint

const RoadSegment = preload("res://addons/road-generator/nodes/road_segment.gd")

signal checkpoint_changed()

## Optional, for you to identify this checkpoint when signals are emitted
@export var number: int = 1
## Optional, for you to identify this checkpoint when signals are emitted
@export var description: String = "Checkpoint"
@export var width: float:
    set(value):
        width = value
        checkpoint_changed.emit()
@export var height: float:
    set(value):
        height = value
        checkpoint_changed.emit()


var shape: BoxShape3D
var collision_shape: CollisionShape3D

func setup(segment: RoadSegment):
    if not shape:
        shape = BoxShape3D.new()
        shape.margin = 0
        var start_point = segment.start_point
        var number_lanes = len(segment.start_point.lanes)
        var lane_width = start_point.lane_width
        var left_margin = start_point.shoulder_width_l + start_point.gutter_profile.x
        var right_margin = start_point.shoulder_width_r + start_point.gutter_profile.x
        var max_margin = max(left_margin, right_margin)
        width = (number_lanes * lane_width) + max_margin * 2
        height = width / 2.0

    shape.size = Vector3(width, height, 1.0)

    if not collision_shape:
        collision_shape = CollisionShape3D.new()
        collision_shape.name = "Checkpoint_of_%s" % segment.start_point.name

        add_child(collision_shape)
        collision_shape.set_owner(get_tree().get_edited_scene_root())
    
    collision_shape.shape = shape
