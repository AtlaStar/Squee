/// @description Insert description here
// You can write your code in this editor


if keyboard_check(ord("A"))
	x -= 10;
if keyboard_check(ord("D"))
	x += 10

if place_meeting(x,y, Object2) {
	hp = clamp(hp -0.05, 0, maxhp)
}
tick_health_ui()
var seq = layer_sequence_get_instance(health_ui)
var debug_flag = true;