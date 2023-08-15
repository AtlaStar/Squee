/// @description Insert description here
// You can write your code in this editor

prop1 = 1;
prop2 = 2;

hp  = 10;
maxhp = 10;

health_ui = layer_gui_sequence_create("GUI_Layer", 0, display_get_gui_height(), Sequence1)

tick_health_ui = function() {
	var _seq_inst = layer_sequence_get_instance(health_ui)
	_seq_inst.hp_mask.scaley = -hp/maxhp;
}
squee_add_sequence_step_event(Sequence1, method(self, tick_health_ui))
sprite_index = Sprite1;