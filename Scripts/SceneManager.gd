extends Node

# Nodes
var ui_title;
var ui_action_btn;
var ui_menu_btn;
var bg_ground;
var bg_top;
var ch_roots;
var ch_tree;
var vfx_fade;
var sound_manager;
var intro_anim;
var logo;

# Transition Params
var transition_ui_time = 0.75;
var transition_scene_time = 1.75;
var next_phase_time = 5.0;
var timer = 0.0;

var in_game = false;
var in_transition = false;
var transition_step = 0;

# Game params
var game_level = 0;
var max_level = 8;

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_title = get_node("UI/Title");
	ui_action_btn = get_node("UI/ActionBtn");
	ui_menu_btn = get_node("UI/MenuBtn");
	bg_ground = get_node("Scene/BG_Ground");
	bg_top = get_node("Scene/BG_Top");
	ch_roots = get_node("Scene/Ch_Roots");
	ch_tree = get_node("Scene/Ch_Tree");
	vfx_fade = get_node("Fade");
	sound_manager = get_node("Sound");
	intro_anim = ch_tree.get_node("IntroAnim");
	logo = vfx_fade.get_node("Logo");
	return

func _process(delta):
	if (in_game):
		if (timer > 0.0):
			timer -= delta;
			if (in_transition): play_transition();
		elif (in_transition): 
			transition_step += 1;
			play_transition();
		elif (!in_transition):
			ui_action_btn.visible = true;
			ui_action_btn.hide_button(Color.white, Color.transparent, 0.5);
			in_game = false;
	return

func play_transition():
	if (game_level == 0):
		phase_1();
	elif (game_level > 0 && game_level < max_level):
		phase_2_to_4(game_level);
	elif (game_level == max_level):
		show_ending();

func goto_next_phase():
	in_game = true;
	in_transition = true;
	transition_step = 0;
	timer = transition_ui_time;
	return

func phase_1():
	match (transition_step):
		0:
			ui_menu_btn.hide_button(Color.transparent, Color.white, transition_ui_time);
			show_title(timer/transition_ui_time, false);
			transition_step += 1;
		1:
			show_title(timer/transition_ui_time, false);
			return
		2:
			timer = 0.5
			transition_step += 1;
		4:
			timer = transition_scene_time;
			ch_roots.change_element(transition_scene_time, 0);
			transition_step += 1;
			return
		6:
			intro_anim.play();
			timer = 8.0;
			transition_step += 1;
			return
		8:
			ch_tree.change_element(0.0, 0, true);
			timer = 0.25;
			transition_step += 1;
			return
		10:
			#Cambiar textura de ui_action_btn
			intro_anim.visible = false;
			ui_menu_btn.visible = false;
			in_transition = false;
			ui_menu_btn.set_stage();
			timer = next_phase_time/2.0;
			print("transition over");
			return
	return

func phase_2_to_4(phase):
	match (transition_step):
		0:
			ui_action_btn.hide_button(Color.transparent, Color.white, transition_ui_time);
			if (phase < 7): sound_manager.fade_bgs(false);
			if (phase == 6): sound_manager.fade_bgm(false);
			transition_step += 1;
			return
		2:
			timer = 0.5
			transition_step += 1;
			return
		4:
			timer = transition_scene_time;
			bg_top.change_element(transition_scene_time, phase);
			bg_ground.change_element(transition_scene_time, phase);
			ch_tree.change_element(transition_scene_time, phase);
			transition_step += 1;
			return
		6:
			if (phase < 7): 
				sound_manager.change_bgs_track(phase);
				sound_manager.fade_bgs(true);
			timer = transition_scene_time;
			ch_roots.change_element(1.0, phase);
			transition_step += 1;
			return
		8:
			#Cambiar textura de ui_btn
			ui_action_btn.visible = false;
			in_transition = false;
			ui_action_btn.set_stage();
			timer = next_phase_time;
			print("transition over");
			return
		
	return

func show_ending():
	match (transition_step):
		0:
			ui_action_btn.hide_button(Color.transparent, Color.white, transition_ui_time);
			sound_manager.fade_bgs(false);
			sound_manager.fade_bgm(false);
			transition_step += 1;
			return
		2:
			timer = 1;
			transition_step += 1;
			return
		4:
			vfx_fade.start_fade(Color.black, Color.transparent, 1.0, true)
			timer = 1.0;
			transition_step += 1;
			return
		6:
			# Start animation;
			# Stop in_game
			sound_manager.change_bgs_track(9);
			sound_manager.fade_bgs(true);
			print("Cinematographic scene here");
			timer = 15.0;
			transition_step += 1;
			return
		8:
			#Fade img
			sound_manager.fade_bgs(false, 10.0);
			timer = 3.0;
			transition_step += 1;
			return
		10:
			vfx_fade.start_fade(Color.white, Color.black, 1.0, true);
			timer = 1.0;
			transition_step += 1;
			return
		12:
			logo.show_logo(Color.white, Color.transparent, 1.0, true);
			timer = 1.0;
			transition_step += 1;
			return
		14:
			timer = 2.0;
			transition_step += 1;
			return
		16:
			logo.change_logo(true);
			timer = 3.0;
			transition_step += 1;
			return
		18:
			logo.show_logo(Color.transparent, Color.white, 1.0, false);
			timer = 1.0;
			transition_step += 1;
			return
		20:
			timer = 0.5;
			transition_step += 1;
			return
		22:
			in_game = false;
			in_transition = false;
			timer = 0.0;
			get_tree().quit();
			return
	return

func show_title(percent, reverse):
	var alpha = 1.0;
	if (reverse):
		alpha = 1.0 - percent;
	else:
		alpha = percent;
	ui_title.add_color_override("font_color", Color(0.42, 0.27, 0.17, alpha));
	return
