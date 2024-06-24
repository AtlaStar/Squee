// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @desc Flattens the activeTracks structs into a format mirroring the assets in the sequence editor. Can be used as a moment, or automatically used if the proper tag is added
/// @desc to the sequence object you intend to allow automatic flattening to occur on.
/// @context {struct.SequenceInstance}

function new_sequence_instance_flatten(_tracks = undefined, _path = []) {
	if is_undefined(_tracks) {
		_tracks = self.activeTracks
	}
	for(var _i = 0; _i < array_length(_tracks); _i++) {
		var _track = _tracks[_i];
		var _t_name = _track.track.name;
		
		//moves to the location in the path where the current active tracks struct should be stored
		var _s = array_reduce(_path, function(_prev, _curr) {
			return _prev[$ _curr]
		}, self)

		_s[$ _t_name] = _track
		
		//recurse if there are nested tracks
		if is_array(_track.activeTracks) && array_length(_track.activeTracks) {
			var _arr = variable_clone(_path)
			array_push(_arr, _t_name)
			new_sequence_instance_flatten(_track.activeTracks, _arr)
		}
	}
	
	//used so that replaced events don't auto-flatten every step once a flattening has occurred.
	return true;
}


/**
 * Deep clones a sequence object struct
 * @param {struct.Sequence} source sequence object struct to clone
 * @returns {struct.Sequence} a new sequence object struct
 */
function sequence_clone(source) {

	/**
	 * Function Description
	 * @param {struct} source Description
	 * @param {any} dest Description
	 */
	function sequence_struct_copy(source, dest) {
		var names = struct_get_names(static_get(source))
		names = array_union(names, struct_get_names(source));
		for(var i = 0; i < array_length(names); i++) {
			var elem = source[$ names[i]]
			//this is just to prevent certain things from being copied in an incorrect manner, or when they are properties not able to be set in this manner
			if names[i] == "tracks" //we set these ourselves, since we don't want to copy the ref
				|| names[i] == "type" //set on creating the struct
				|| names[i] == "subType" //used for built in property tracks
				|| names[i] == "linked" //unsure
				|| names[i] == "linkedTrack" //unsure
				|| (names[i] == "curve" && !animcurve_exists(elem)) //gets pissy if you try and set it to non-existant animcurve, or even the default sentinel value of -1
				|| (names[i] == "mask") //property is automagically set when the track is set.
				|| (names[i] == "subject") //automagically set property
				|| (names[i] == "keyframes") //we set these ourselves.
				|| (names[i] == "channels") //we set these ourselves.
					continue;
			dest[$ names[i]] = source[$ names[i]]
		}
	}
	
	/**
	 * internal function to clone a sequence track
	 * @param {array.Track} tracks a sequence track to clone
	 * @returns {array.Track} a new sequence track deep cloned from the source
	 */
	function sequence_track_clone(tracks) {

		var tr = []
		for(var i = 0; i < array_length(tracks); i++) {
			var _type = tracks[i].type;
			var _track = sequence_track_new(_type)
			var kf = [];
			var e1 = tracks[i]
			for(var j = 0; j < array_length(e1.keyframes); j++) {
				var _keyframe = sequence_keyframe_new(_type)
				var kd = [];
				var e2 = e1.keyframes[j]
				for(var k = 0; k < array_length(e2.channels); k++) {
					var _keydata = sequence_keyframedata_new(_type)
					var e3 = e2.channels[k];
					sequence_struct_copy(e3, _keydata)
					array_push(kd, _keydata)
				}
				sequence_struct_copy(e2, _keyframe)
				array_push(kf, _keyframe)
				_keyframe.channels = kd;
			}
			
			//these track types don't have keyframes, and trying to set a keyframe array corrupts the struct
			if _type != seqtracktype_clipmask && _type != seqtracktype_clipmask_mask && _type != seqtracktype_clipmask_subject {
				_track.keyframes = kf;
			}
			
			sequence_struct_copy(e1, _track)
			array_push(tr, _track)
			_track.tracks = sequence_track_clone(tracks[i].tracks)
		}
		return tr;
	}
	var seq = sequence_create();
	sequence_struct_copy(source, seq)
	//the tracks get reversed somehow when converting the sequence ref into a struct, so layer order gets reversed unless you do this
	seq.tracks = array_reverse(sequence_track_clone(source.tracks))

	seq.momentKeyframes = variable_clone(source.momentKeyframes, 0) //shallow copy for now
	seq.messageEventKeyframes = variable_clone(source.momentKeyframes, 0) //shallow copy for now
	return seq;
}


/**
 * Creates a general Squee sequence element container, and performs a deep copy of the passed element. 
 * @param {any*} layer_id The layer to create the sequence on
 * @param {any} element The Sequence Object, Asset, or SqueeElement to build it from.
 * @param {bool} [_tick_on_create]=false Whether the sequence should tick its update on the frame it is created
 */
function SqueeElement(layer_id, element, _tick_on_create = false) constructor {

	element = is_handle(element) ? squee_ini([element])[0] : element;
	element = is_instanceof(element, SqueeElement) ? element.__sequence : element;
	__seq_element = -1;
	__sequence = sequence_clone(element)
	__layer = layer_id;
	__play_callback = function() {return __status == SQUEE_SEQ_STATE.BEGIN}
	__stop_callback = function() {return false}
	__destroy_callback = function() {return false}
	__on_finished = function() {}
	__status = SQUEE_SEQ_STATE.BEGIN
	
	/// Adds a step event to the step event queue
	/// @param callback The function to enqueue
	/// @context {struct.SqueeElement}
	static add_step_event = function(callback) {
		array_push(__sequence[$ "event_step_callbacks"] ?? [], callback)
		return self;
	}
	
	/// Adds a begin step event to the begin step event queue
	/// @param callback The function to enqueue
	/// @context {struct.SqueeElement}
	static add_begin_step_event = function(callback) {
		array_push(__sequence[$ "event_step_begin_callbacks"] ?? [], callback)
		return self
	}

	/// Adds an end step event to the end step event queue
	/// @param callback The function to enqueue
	/// @context {struct.SqueeElement}
	static add_end_step_event = function(callback) {
		array_push(__sequence[$ "event_step_end_callbacks"] ?? [], callback)
		return self;
	}

	/// Adds a create event to the create event queue
	/// @param callback The function to enqueue
	/// @context {struct.SqueeElement}
	static add_create_event = function(callback) {
		array_push(__sequence[$ "event_create_callbacks"] ?? [], callback)
		return self;
	}
	
	/// Adds a destroy event to the destroy event queue
	/// @param callback The function to enqueue
	/// @context {struct.SqueeElement}
	static add_destroy_event = function(callback) {
		array_push(__sequence[$ "event_destroy_callbacks"] ?? [], callback)
		return self;
	}
	/// Adds a cleanup event to the cleanup event queue
	/// @param callback The function to enqueue
	/// @context {struct.SqueeElement}
	static add_cleanup_event = function(callback) {
		array_push(__sequence[$ "event_cleanup_callbacks"] ?? [], callback)
		return self;
	}
	/// Adds an async system event to the async system event queue
	/// @param callback The function to enqueue
	/// @context {struct.SqueeElement}
	static add_async_system_event = function(callback) {
		array_push(__sequence[$ "event_async_system_callbacks"] ?? [], callback)
		return self;
	}
	/// Adds a broadcast message event to the broadcast message event queue
	/// @param callback The function to enqueue
	/// @context {struct.SqueeElement}
	static add_broadcast_message_event = function(callback) {
		array_push(__sequence[$ "event_broadcast_message_callbacks"] ?? [], callback)
		return self;
	}

	///Sets a trigger that is used to start playing of a created sequence
	/// @param trigger the trigger function to use. Should return a bool value
	/// @context {struct.SqueeElement}
	static set_play_trigger = function(trigger) {
		__play_callback	= trigger;
		return self;
	}
	///Sets a trigger that is used to pause playing of a created sequence
	/// @param trigger the trigger function to use. Should return a bool value
	/// @context {struct.SqueeElement}
	static set_stop_trigger = function(trigger) {
		__stop_callback	= trigger;
		return self;
	}
	///Sets a trigger that is used to destroy a playing sequence
	/// @param trigger the trigger function to use. Should return a bool value
	/// @context {struct.SqueeElement}
	static set_destroy_trigger = function(trigger) {
		__destroy_callback = trigger;	
	}

	///Sets a callback that is called when the sequence finishes playing. Only applicable to sequences that do not loop or reverse
	/// @param callback the trigger function to use. Should return a bool value
	/// @context {struct.SqueeElement}
	static set_on_finished_callback = function(callback) {
		__on_finished = callback
		return self;
	}

	/// Creates the sequence at the passed position, and pauses it. Will destroy a sequence already created by this
	/// before creating a new one.
	/// @context {struct.SqueeElement}
	static create_sequence = function(_x, _y) {
		if layer_sequence_exists(__layer, __seq_element){
			layer_sequence_destroy(__seq_element)
		}
		__seq_element = layer_sequence_create(__layer, _x, _y, __sequence)
		layer_sequence_pause(__seq_element)
		return self;
	}
	
	enum SQUEE_SEQ_STATE {
		BEGIN,
		ERROR,
		PLAYING,
		STOPPED,
		FINISHED
	}
	
	/// Calls an update tick for the sequence
	/// @context {struct.SqueeElement}
	static update = function() {
		if __play_callback() {
			layer_sequence_play(__seq_element)
			__status = SQUEE_SEQ_STATE.PLAYING
		}
		if __stop_callback() {
			layer_sequence_pause(__seq_element)
			__status = SQUEE_SEQ_STATE.STOPPED
		}
		if layer_sequence_is_finished(__seq_element) && __status != SQUEE_SEQ_STATE.FINISHED {
			__status = SQUEE_SEQ_STATE.FINISHED
			__on_finished();
		}
		if __destroy_callback() {
			__status = SQUEE_SEQ_STATE.BEGIN;
			layer_sequence_destroy(__seq_element)
			__seq_element = -1;
		}
		return __status;
	}
}


//unfinished
function SqueeReplacementTestElement(layer_id, element, _tick_on_create = false) : SqueeElement(layer_id, element, _tick_on_create) constructor {
	/*
	for(var i = 0; i < array_length(__sequence.tracks); i++) {
		var track = __sequence.tracks[i];
		if track.type == seqtracktype_instance && track.name = "Object2" {
			track.keyframes[0].channels[0].objectIndex = obj_shield_anchor_test
				
			var kf = sequence_keyframe_new(seqtracktype_instance)
			var kd = sequence_keyframedata_new(seqtracktype_instance)
			kf.channels = [kd]
			kd.channel = 0;
			kd.objectIndex = __squee_obj_holder
			kf.frame = 0;
			kf.length = 1;
			var arr = [kf]
			for(var j = 0; j < array_length(track.keyframes); j++) {
				array_push(arr, track.keyframes[j])
			}
			track.keyframes = arr;
		}
	}*/
}

/**
 * Function Description
 * @param {any*} layer_id Description
 * @param {any} element Description
 * @param {bool} [_tick_on_create]=true Description
 */
function SqueeAnchorElement(layer_id, element, _tick_on_create = true): SqueeElement(layer_id, element, _tick_on_create) constructor  {
	
	static ticking_elements = [];
	
	__xoffset = 0;
	__yoffset = 0;
	__subject = noone;
	__slots = {};
	
	//extract the keyframe data structs for any AnchorPoint objects. 
	for(var i = 0; i < array_length(__sequence.tracks); i++) {
		var track = __sequence.tracks[i];
		if track.type == seqtracktype_instance 
			&& ( track.keyframes[0].channels[0][$ "objectIndex"] == AnchorPoint
				//yes, this is in fact stupid af, but it prevents a crash due to a weird engine bug
				|| track.keyframes[0].channels[0][$ "particleSystemIndex"] == AnchorPoint
			)
			__slots[$ track.name] = track.keyframes[0].channels[0]
	}

	///Set an existing anchor point to a new object type
	/// @param anchor_name the track name where the anchor exists to replace
	/// @param replacement the object_index to replace the AnchorPoint object with
	/// @context {struct.SqueeAnchorElement}
	static set_anchor = function(anchor_name, replacement) {
		var _slot = __slots[$ anchor_name]
		if  _slot {
			if _slot[$ "objectIndex"]
				_slot.objectIndex = replacement;
			else
				_slot.particleSystemIndex = replacement
		}
		
		return self;
	}
	static set_subject = function(replacement) {
		__subject = replacement
		return self
	}
	
	static update = function() {
		static super = SqueeElement.update;
		layer_sequence_x(__seq_element, __subject.x + __xoffset)
		layer_sequence_y(__seq_element, __subject.y + __yoffset)
		if super() == SQUEE_SEQ_STATE.FINISHED {
			layer_sequence_destroy(__seq_element)
			__status = SQUEE_SEQ_STATE.BEGIN
			create_sequence();
		}
	}
	
	///@ignore
	static replace_anchors = function(_tracks) {
		for(var _i = 0; _i < array_length(_tracks); _i++) {
			var _track = _tracks[_i]
			var _name = _track.name
			if is_array(_track.tracks) {
				replace_anchors(_track.tracks)
			}
			if  _track.type == seqtracktype_instance {
				var _kfdata = _track.keyframes[0].channels[0]
				var _key = _kfdata[$ "objectIndex"] != undefined ? "objectIndex" : "particleSystemIndex";
				_track.visible = _kfdata[$ _key] != AnchorPoint
			}
		}
	}

	static create_sequence = function() {
		//if we don't save function as a var, the call context ends up being the static and not the callsite
		static super = SqueeElement.create_sequence
		replace_anchors(__sequence.tracks)
		super(__subject.x, __subject.y)
		sequence_instance_override_object(layer_sequence_get_instance(__seq_element), __subject.object_index, __subject)
		array_push(ticking_elements, method(self, update))
		return self;
	}
}

///@ignore
function squee_ini(sequences = []) {
	sequences = array_map(sequences, function(elem) {
		return is_handle(elem) ? sequence_get(elem) : elem;
	})

	array_foreach(sequences, function(elem) {
		static tokens = ["event_create", "event_destroy", "event_clean_up", "event_step_begin", "event_step_end", "event_async_system", "event_broadcast_message", "event_step"]
		static event_overrides = {
			event_create: function() {
				array_foreach(sequence.event_create_callbacks, function(func) {
					func();	
				})
			},
			event_destroy: function() {
				array_foreach(sequence.event_destroy_callbacks, function(func) {
					func();	
				})
			},
			event_clean_up: function() {
				array_foreach(sequence.event_clean_up_callbacks, function(func) {
					func();	
				})
			},
			event_step_begin: function() {

				array_foreach(sequence.event_step_begin_callbacks, function(func) {
					func();	
				})
			},
			event_step_end: function() {
				array_foreach(sequence.event_step_end_callbacks, function(func) {
					func();	
				})
			},
			event_async_system: function() {
				array_foreach(sequence.event_async_system_callbacks, function(func) {
					func();	
				})
			},
			event_broadcast_message: function() {
				array_foreach(sequence.event_broadcast_message_callbacks, function(func) {
					func();	
				})
			},
			event_step: function() {
				self[$ "is_flattened"]  = self[$ "is_flattened"] ?? new_sequence_instance_flatten()
				if sequence.name == "Sequence4" && self.Object2.instanceID != noone {
					var debug = 10;
				}
				array_foreach(sequence.event_step_callbacks, function(func) {
					func();
				})
			}
		}
		
		for(var i = 0; i < array_length(tokens); i++) {
			var value = elem[$ tokens[i]];
			elem[$ tokens[i] + "_callbacks"] = value ? [value] : [];
			elem[$ tokens[i]] = method(undefined, event_overrides[$ tokens[i]])
		}
	})
	return sequences
}