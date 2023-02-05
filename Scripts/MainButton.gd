extends TextureButton

export var is_active:bool;

var scene_manager;
var on_transition;

var tween:Tween

func _ready():
	scene_manager = get_node("/root/MainScene");
	scene_manager.game_level = 0;
	tween = Tween.new();
	add_child(tween);
	self.visible = is_active;
	return

func _on_TextureButton_pressed():
	if (on_transition): return;

	on_transition = true;
	if (scene_manager.game_level <= scene_manager.max_level):
		scene_manager.goto_next_phase();
	return

func set_stage():
	if (scene_manager.game_level == scene_manager.max_level):
		scene_manager.game_level = 0;
	else:
		scene_manager.game_level += 1;
	on_transition = false;
	return

func hide_button(target_color, current_color, time):
	tween.interpolate_property(self, "modulate", current_color, target_color, time);
	tween.start();
	return
