// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


/// @desc Allows one to access sequence properties through named accessors rather than the nested activeTracks structs.
/// @desc Uses the fact that the structuring of the tracks structs mirrors the layout of the sequences activeTracks
/// @param {array<struct.Track>} [_tracks] a GML tracks struct, gotten from the sequence instance or tracks struct
/// @param {array<real>} [_array=[]] INTERNAL USE ONLY: ALWAYS USE DEFAULT VALUE
/// @context {struct.SequenceInstance}
function sequence_instance_flatten(_tracks = undefined, _array = []) {
	// This is so we can call this function as a moment on a sequence struct
	if is_undefined(_tracks) {
		_tracks = sequence.tracks
	}
		
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
	obj_sequence.original_step_event = _event
}

function squee_add_sequence_step_event(obj_sequence, _event = function(){}) {
	if squee_is_enabled(_GMFUNCTION_) {
		return __intern_squee_add_sequence_step_event(obj_sequence, _event)	
	}
}
squee_enable_default(squee_add_sequence_step_event)

function event_step_replacement() {
	var is_seq_obj = false;
	try {
		var t = sequence;
	} catch(e) {
		is_seq_obj = true;	
	}
	
	if is_seq_obj
		exit;
	
	if squee_is_enabled(squee_auto_flatten) {
		squee_auto_flatten();
	}
	if squee_is_enabled(squee_track_callbacks) {
		squee_track_callbacks()
	}
	original_step_event();
}
squee_enable_default(event_step_replacement)

///@context {struct.SequenceInstance}
function squee_auto_flatten() {
	if !flatten_complete {
		sequence_instance_flatten();
		flatten_complete = true;
	}
}
squee_enable_default(squee_auto_flatten)

///@context {struct.SequenceInstance}
function squee_track_callbacks() {
	var _tracks = struct_get_names(self)
	array_foreach(_tracks, function(_elem) {
		var _call = tag_get_asset_ids(sequence.name + "_" +_elem, asset_script)
		with(self[$ _elem]) {
			array_foreach(_call, function(_elem) {
				script_execute(_elem)
			})
		}
	})
}
squee_enable_default(squee_track_callbacks)

function squee_add_track_callback(obj_sequence, track_name, script_function) {
	if !is_struct(obj_sequence) {
		obj_sequence = sequence_get(obj_sequence)
	}

	if is_method(script_function)
		script_function = method_get_index(script_function)
	asset_add_tags(script_function, $"{obj_sequence.name}_{track_name}", asset_script)
}

function squee_enable_default(gm_func) {
	asset_add_tags(gm_func, SqueeEnabledFeature(), asset_script)
}
function squee_is_enabled(_feature) {
	if is_method(_feature) 
		_feature = method_get_index(_feature)
	return asset_has_any_tag(_feature, [SqueeUIEnabledFeature(), SqueeEnabledFeature()], asset_script)	
}

function squee_sequence_map_anchor(sequence, property, index) {
	static keystore = {}
	var _key = string(sequence.name)
	keystore[$ _key] ??= {}
	keystore[$ _key][$ property] = index;
	//show_debug_message(keystore)
}
static_set(static_get(squee_sequence_map_anchor), {keystore: {}})
squee_sequence_map_anchor(sequence_get(seq_anchor_tester), "sword_slot", obj_sword_anchor_test)


//TO-DO: Full rewrite. Should be used to generate a new sequence from a template
function squee_auto_replace_anchors(_tracks = undefined) {
	// This is so we can call this function as a moment on a sequence struct
	if is_undefined(_tracks) {
		_tracks = sequence.tracks
	}
	
	//iterate through all tracks, check if an AnchorPoint object is stored there
	for(var _i = 0; _i < array_length(_tracks); _i++) {
		var _track = _tracks[_i]
		var _name = _track.name
		if is_array(_track.tracks)
			squee_auto_replace_anchors(_track.tracks)
		if  _track.type == seqtracktype_instance {
			var _value = (squee_sequence_map_anchor.keystore[$ sequence.name] ?? {})
			_value = _value[$ _track.name] ?? noone;
			if (_track.keyframes[0].channels[0].objectIndex == AnchorPoint) {
				if _value > -1 {
					_track.keyframes[0].channels[0].objectIndex = _value;
				}
				else
					_track.visible = false;
			}
		}
	}
}

function update_anchor_sequence(sequence_id) {
	layer_sequence_x(sequence_id, x)
	layer_sequence_y(sequence_id, y)
}

squee_enable_default(squee_auto_replace_anchors)


function SqueeAnchorElement(layer_id, element) constructor {

	var update_sequence = function() {
		layer_sequence_x(seq_element, inst.x)
		layer_sequence_y(seq_element, inst.y)
	}
	
	inst = other;
	seq_element = layer_sequence_create(layer_id, inst.x, inst.y, element)
	sequence_instance_override_object(layer_sequence_get_instance(seq_element), inst.object_index, inst)
	timesource = time_source_create(time_source_game, 1, time_source_units_frames, update_sequence, [],-1)
	time_source_start(timesource)
}