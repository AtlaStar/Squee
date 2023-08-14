// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


///@returns {struct.SequenceBuilder}
function SequenceBuilder(_name) constructor
{
	///@ignore
	__name = _name
	///@ignore
	__loopmode = seqplay_oneshot;
	///@ignore
	__playback_speed = game_get_speed(gamespeed_fps);
	///@ignore
	__playback_speed_type = spritespeed_framespersecond;
	///@ignore
	__length = 1;
	///@ignore
	__volume = 1;
	///@ignore
	__xorigin = 0;
	///@ignore
	__yorigin = 0;
	///@ignore
	__message_event_keyframes = [];
	///@ignore
	__moment_keyframes = [];
	///@ignore
	__tracks = [];
	
	static loopmode_oneshot = function() {
		__loopmode = seqplay_oneshot
		return self;
	}
	static loopmode_pingpong = function() {
		__loopmode = seqplay_pingpong
		return self;
	}
	static loopmode_repeat = function() {
		__loopmode = seqplay_loop
		return self;
	}
	
	/// @desc Specifies that playback_speed should be in frames per second
	///		then sets the speed
	/// @param {real} _speed the frames per second
	static playback_speed_as_fps = function(_speed) {
		__playback_speed = _speed;
		__playback_speed_type = spritespeed_framespersecond
		return self;
	}
	
	/// @desc Specifies that playback_speed should be frames per game frame
	///		then sets the speed
	/// @param {real} _speed the number of frames that occur per game frame
	static playback_speed_as_fpgf = function(_speed) {
		__playback_speed = _speed
		__playback_speed_type = spritespeed_framespergameframe
		return self;
	}
	
	///@context {struct.SequenceBuilder}
	static name = function(_name) {
		__name = _name
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	
	static volume = function(_volume) {
		__volume = _volume
		return self
	}
	
	static xorigin = function(_xorigin) {
		__xorigin = _xorigin
		return self
	}
	static yorigin = function(_yorigin) {
		__yorigin = _yorigin
		return self
	}
	
	static add_track = function(_track) {
		array_push(__tracks, _track)
		return self;
	}
	
	static add_message = function() {
		var _message = new MessageKeyframe(self)
		array_push(__message_event_keyframes, _message)
		return _message;
	}
	
	static add_moment = function() {
		var _moment = new MomentKeyframe(self)
		array_push(__moment_keyframes, _moment)
		return _moment;
	}
	
	///@returns {Struct.Sequence}
	static build = function() {
		var _seq = sequence_create();
		_seq.name = __name;
		_seq.playbackSpeed = __playback_speed
		_seq.playbackSpeedType = __playback_speed_type
		_seq.loopmode = __loopmode
		_seq.length = __length;
		_seq.volume = __volume
		_seq.xorigin = __xorigin
		_seq.yorigin = __yorigin
		_seq.tracks = array_map(__tracks, intern_sequence_builder)
		_seq.momentKeyframes = array_map(__moment_keyframes, intern_sequence_builder)
		_seq.messageEventKeyframes = array_map(__message_event_keyframes, intern_sequence_builder)
		return _seq;
	}
}

///@ignore
function intern_sequence_builder(_elem) {
	return _elem.build()
}
