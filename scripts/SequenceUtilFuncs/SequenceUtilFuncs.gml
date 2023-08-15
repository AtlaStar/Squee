// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


/// @desc Allows one to access sequence properties through named accessors rather than the nested activeTracks structs.
/// @desc Uses the fact that the structuring of the tracks structs mirrors the layout of the sequences activeTracks
/// @param {array<struct.Track>} [_tracks] a GML tracks struct, gotten from the sequence instance or tracks struct
/// @param {array<real>} [_array=[]] INTERNAL USE ONLY: ALWAYS USE DEFAULT VALUE
/// @context {struct.SequenceInstance}
function sequence_instance_flatten(_tracks = undefined, _array = []) {
	// This is so we can call this function as a moment on a sequence struct
	if is_undefined(_tracks)
		_tracks = sequence.tracks;
		
	static should_discard_name = function(_name) {
		//there may be more unknown names that need to be filtered
		static names = [
			"position",
			"origin",
			"",
			"scale",
			"Clipping Mask",
			"rotation",
			"mask",
			"image_speed",
			"image_index",
			"subject",
			"blend_multiply",
			"gain",
			"pitch",
			"frameSize",
			"characterSpacing",
			"lineSpacing",
			"paragraphSpacing"
		]
		//lazy way to check if the passed name exists in the blacklist. Probably will be slower than checking a struct key
		return array_length(array_intersection(names, [_name]));
	}
	
	//iterate through all tracks, create an array of idxs by name, and generate a method to traverse through the active tracks when it exists
	for(var _i = 0; _i < array_length(_tracks); _i++) {
		var _track = _tracks[_i]
		var _name = _track.name
		array_push(_array, _i)
		if is_array(_track.tracks)
			sequence_instance_flatten(_track.tracks, _array)
		if !should_discard_name(_name) {
			self[$ _name] = array_reduce(_array, function(_track, _idx) { return _track.activeTracks[_idx]}, self)
		}
		array_pop(_array)
	}
}

function __intern_squee_add_sequence_step_event(obj_sequence, _event = function(){}) {

	if(!is_struct(obj_sequence)) {
		obj_sequence = sequence_get(obj_sequence)	
	}
	
	var _ret = {original_step_event: _event}
	if variable_struct_exists(obj_sequence, "original_step_event") {
		obj_sequence.original_step_event = _event;
	}
	return _ret
}

function squee_add_sequence_step_event(obj_sequence, _event = function(){}) {
	if squee_is_enabled(_GMFUNCTION_) {
		return __intern_squee_add_sequence_step_event(obj_sequence, _event)	
	}
}
squee_enable_default(squee_add_sequence_step_event)

function event_step_replacement() {
	if squee_is_enabled("auto_flatten") {
		auto_flatten();	
	}
	try {
		sequence.original_step_event();
	} catch(e) {
		show_debug_message(e)
	}
}
squee_enable_default(event_step_replacement)

///@context {struct.SequenceInstance}
function auto_flatten() {
	if !flatten_complete {
		sequence_instance_flatten();
		flatten_complete = true;
	}
}
squee_enable_default(auto_flatten)

function squee_enable_default(gm_func) {
	asset_add_tags(gm_func, "SqueeUIEnabledFeature", asset_script)
}

function squee_is_enabled(_feature) {
	return asset_has_any_tag(_feature, ["SqueeUIEnabledFeature", "SqueeEnabledFeature"], asset_script)	
}