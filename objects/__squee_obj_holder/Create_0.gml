/// @description Insert description here
// You can write your code in this editor


__squee_holder_callback = function() {
	show_debug_message(visible)
}
__squee_holder_timesource = time_source_create(time_source_game, 1, time_source_units_frames, __squee_holder_callback, [], -1)
time_source_start(__squee_holder_timesource)

show_debug_message("in holder")