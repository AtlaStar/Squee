/// @description Insert description here
// You can write your code in this editor

prop1 = 1;
prop2 = 2;

hp  = 10;
maxhp = 10;

health_ui = layer_gui_sequence_create("GUI_Layer", 0, 2400, Sequence1)

slots = layer_sequence_create("Instances_Sublayer", x, y, seq_anchor_tester)

function tick_health_ui() {
	var _seq_inst = layer_sequence_get_instance(health_ui)
	_seq_inst.hp_mask.scaley = -hp/maxhp;
}

function tick_health_callback() {
	show_debug_message(self)
}
//squee_add_track_callback(Sequence1,"hp_mask",tick_health_callback)

squee_add_sequence_step_event(Sequence1, method(self, tick_health_ui))

var seq_inst = layer_sequence_get_instance(health_ui)

seq_inst.original_step_event = method(self, tick_health_ui)
sprite_index = Sprite1;

