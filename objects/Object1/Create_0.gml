/// @description Insert description here
// You can write your code in this editor

prop1 = 1;
prop2 = 2;

hp  = 10;
maxhp = 10;

health_ui = layer_gui_sequence_create("GUI_Layer", 0, display_get_gui_height(), Sequence1)

function tick_health_ui() {
	var _seq_inst = layer_sequence_get_instance(health_ui)
	_seq_inst.hp_mask.scaley = -hp/maxhp;
}

sprite_index = Sprite1;