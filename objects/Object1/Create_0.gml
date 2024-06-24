/// @description Insert description here
// You can write your code in this editor

hp  = 10;
maxhp = 10;

health_ui = new SqueeUICanvasElement("GUI_Layer", 0, display_get_gui_height(), Sequence1)
slots = new SqueeAnchorElement("Instances_Sublayer", seq_anchor_tester)
dragons = layer_sequence_create("Instances", x, y, Sequence3)
test4 = new SqueeReplacementTestElement("Instances", Sequence4)
test4.create_sequence(x + 30, y + 30)


var elem = layer_sequence_get_instance(dragons)

slots.set_anchor("sword_slot", obj_sword_anchor_test)
slots.set_anchor("shield_slot", obj_shield_anchor_test)
slots.set_subject(self)
slots.create_sequence();
slots.set_play_trigger(function() {
	return mouse_check_button_pressed(mb_left)
})

function tick_health_ui() {
	var _seq_inst = layer_sequence_get_instance(health_ui.__seq_element)
	_seq_inst.HPOrbMask.mask.hp_mask.scaley = -hp/maxhp;
}

health_ui.add_step_event(method(self, tick_health_ui))
health_ui.create_sequence();
//health_ui.sequence_instance_step_event( method(self, tick_health_ui))
sprite_index = Sprite1;