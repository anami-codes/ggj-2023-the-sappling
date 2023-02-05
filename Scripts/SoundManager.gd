extends Node

export var sounds = [];

var bgm;
var bgs;

var timer = 0.0;
var default_transition_time = 2.0;
var transition_time = 0.0;
var in_transition = false;

var bgm_volume_up = 80;
var bgs_volume_up = 10;
var volume_down = 80;

var bgm_add_value = 0;
var bgs_add_value = 0;


func _ready():
	bgm = get_node("BGM");
	bgs = get_node("BGS");
	fade_bgm(true);
	fade_bgs(true);
	return


func _process(delta):
	if (in_transition):
		if(timer > 0.0):
			timer -= delta
			fix_volume(delta/transition_time);
		else:
			bgm_add_value = 0.0;
			bgs_add_value = 0.0;
			in_transition = false;

	return

func fix_volume(delta):
	var bgm_add = bgm_add_value * delta;
	var bgs_add = bgs_add_value * delta;

	bgm.set_volume_db(bgm.get_volume_db() + (bgm_add ));
	bgs.set_volume_db(bgs.get_volume_db() + (bgs_add));
	return

func change_bgs_track(next_phase):
	var next_track = 0;
	if (next_phase == 1 || next_phase == 3 || next_phase == 5): 
		next_track = 1;
	elif (next_phase == 6 || next_phase == 7):
		next_track = 2;
	elif(next_phase == 8):
		next_track = 3;
	elif(next_phase == 9):
		next_track = 4;
	var track = sounds[next_track] as AudioStream;
	bgs.set_stream(track);
	return

func fade_bgs(turn_up, time = 0.0):
	if(turn_up):
		bgs_add_value = volume_down - bgs_volume_up;
		bgs.set_volume_db(volume_down * -1.0);
	else:
		bgs_add_value = bgs_volume_up - volume_down;
		bgs.set_volume_db(bgs_volume_up * -1.0);

	if (time == 0.0):
		transition_time = default_transition_time;
	else:
		transition_time = time;
	timer = transition_time;
	in_transition = true;
	bgs.play();
	return

func fade_bgm(turn_up, time = 0.0):
	if(turn_up):
		bgm_add_value = volume_down - bgm_volume_up;
		bgm.set_volume_db(volume_down * -1.0);
	else:
		bgm_add_value = bgm_volume_up - volume_down;
		bgm.set_volume_db(bgm_volume_up * -1.0);

	if (time == 0.0):
		transition_time = default_transition_time;
	else:
		transition_time = time;
	timer = transition_time;
	in_transition = true;
	bgm.play();
	return
