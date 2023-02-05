extends Node

export var title_end:NodePath

var tween:Tween

func _ready():
	tween = Tween.new();
	add_child(tween);
	var t = get_node(title_end);
	t.visible = false;
	start_fade(Color.transparent, Color.white, 1.0, false)
	return


func start_fade(target_color, current_color, time, show):
	self.modulate = current_color;
	self.visible = true;
	tween.interpolate_property(self, "modulate", current_color, target_color, time);
	tween.start();
	yield(tween, "tween_completed")
	self.visible = show;

func show_title(target_color, current_color, time, show):
	var t = get_node(title_end);
	t.modulate = current_color;
	t.visible = true;
	tween.interpolate_property(t, "modulate", current_color, target_color, time);
	tween.start();
	yield(tween, "tween_completed")
	t.visible = show;