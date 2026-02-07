extends Node

class_name StateManager

enum State {ALLRANGE, STARFOX}

@export var states = {}

func _ready():
	var stateNodes = get_children()
	var i = 0
	for state in State:
		states[state] = stateNodes[i]
		i += 1
	print("STATES:	", str(states))

func GetState(state : State):
	return states[State.keys()[state]]
