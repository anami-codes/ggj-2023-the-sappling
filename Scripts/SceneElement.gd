extends Node2D

export var textures = []

var tween:Tween
var front_element
var back_element

func _ready():
	front_element = get_node("Front");
	back_element = get_node("Back");
	tween = Tween.new();
	front_element.add_child(tween);
	return

func change_element(time, current_phase):
	back_element.set_texture(front_element.get_texture());
	front_element.modulate = Color.transparent;
	var tex = textures[current_phase] as Texture;
	front_element.set_texture(tex);

	tween.interpolate_property(front_element, "modulate", Color.transparent, Color.white, time);
	tween.start();
	yield(tween, "tween_completed")
