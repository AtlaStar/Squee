/// @description Insert description here
// You can write your code in this editor

prop1 = 1;
prop2 = 2;

hp  = 10;
maxhp = 10;

health_ui = new SqueeUICanvasElement("GUI_Layer", 0, display_get_gui_height(), Sequence1)
slots = new SqueeAnchorElement("Instances_Sublayer", seq_anchor_tester)

function tick_health_ui() {
	var _seq_inst = layer_sequence_get_instance(health_ui.seq_element)
	_seq_inst.hp_mask.scaley = -hp/maxhp;
}

health_ui.sequence_instance_step_event( method(self, tick_health_ui))
sprite_index = Sprite1;

