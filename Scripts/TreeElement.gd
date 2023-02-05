extends Node2D

export var states = []

var current_state;
var next_state;
var current_tween:Tween
var next_tween:Tween

func _ready():
	current_tween = Tween.new();
	next_tween = Tween.new();
	current_state = get_node(states[0]);
	add_child(current_tween);
	add_child(next_tween);
	return

func change_element(time, phase, instant=false):
	next_state = get_node(states[phase + 1]) as Node;

	if(instant):
		next_state.visible = true;
		current_state.visible = false;
		current_state = next_state;
		return
	
	next_state.modulate = Color.transparent;
	next_state.visible = true;

	current_tween.interpolate_property(current_state, "modulate", Color.white, Color.transparent, time);
	next_tween.interpolate_property(next_state, "modulate", Color.transparent, Color.white, time);
	current_tween.start();
	next_tween.start();
	yield(current_tween, "tween_completed")
	current_state.visible = false;
	current_state = next_state;
