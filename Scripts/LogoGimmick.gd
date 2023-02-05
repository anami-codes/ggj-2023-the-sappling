extends Sprite

export var textures = [];

var tween:Tween
var timer = 0.0;

func _ready():
	tween = Tween.new();
	add_child(tween);
	self.visible = false;
	return

func _process(delta):
	if (timer > 0.0):
		timer -= delta;
		if (timer <= 0.0):
			change_logo(false);
	return

func show_logo(target_color, current_color, time, show):
	self.modulate = current_color;
	self.visible = true;
	tween.interpolate_property(self, "modulate", current_color, target_color, time);
	tween.start();
	yield(tween, "tween_completed")
	self.visible = show;

func change_logo(ewe=false):
	if (ewe):
		region_rect = Rect2(0, 504, 1300, 500);
		timer = 0.5;
	else:
		region_rect = Rect2(0, 0, 1300, 500);
	return