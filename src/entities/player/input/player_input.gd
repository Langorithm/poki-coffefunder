@abstract
class_name PlayerInput
extends Node

## Abstract base for all player input sources.
## Extend this for LocalPlayerInput, NetworkPlayerInput, etc.
## Player only holds a reference typed as PlayerInput — never to a concrete subclass.
##
## Required Input Map actions (set in Project Settings):
##   move_left, move_right, move_up, move_down
##   aim_left, aim_right, aim_up, aim_down
##   special

## Normalized movement vector [-1, 1] on both axes.
var motion_vector: Vector2 = Vector2.ZERO

## Normalized aim vector [-1, 1] on both axes. Zero when not aiming.
var aim_vector: Vector2 = Vector2.ZERO

## Emitted once per press. Player decides what the special action does.
signal special_pressed

## Emitted on right-stick tap (pressed but no significant direction).
## Receiver should resolve the nearest enemy and synthesize an aim_vector.
signal auto_aim_requested
