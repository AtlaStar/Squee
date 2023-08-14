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


function event_step_replacement() {
	static completed = false
	if !completed {
		sequence_instance_flatten();
		completed = true;
	}
	original_step_event();
}
asset_add_tags(event_step_replacement, ["SqueeUIEnabledFeature","SqueeUIReplacementFunction"], asset_script)