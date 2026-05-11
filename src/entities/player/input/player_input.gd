@abstract
class_name PlayerInput
extends Node

## Abstract interface between any input source and the Player.
## Defines what Player can read (motion_vector, aim_vector) and what events it can receive.
## Knows nothing about how input is gathered — that belongs to concrete subclasses.

## Normalized movement vector [-1, 1] on both axes.
var motion_vector: Vector2 = Vector2.ZERO

## Normalized aim vector [-1, 1] on both axes. Zero when not aiming.
var aim_vector: Vector2 = Vector2.ZERO

## True when aim is coming from an analog source (joystick, touch). False on mouse.
var is_analog_aim: bool = false

## Emitted once per press. Player decides what the special action does.
signal special_pressed

## Emitted when the player triggers the aim input.
## direction is where the player was aiming at the moment of trigger, normalized.
## Vector2.ZERO means no explicit direction was given.
signal aim_triggered(direction: Vector2)
