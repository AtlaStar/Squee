// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


/// @desc Function Description
/// @param {struct.TrackWrapper| struct.SequenceBuilder} _context Description
function KeyframeWrapper(_context) constructor {
	///@ignore
	channel_id = 0;
	///@ignore
	__type = seqtracktype_empty;
	///@ignore
	__frame = 0;
	///@ignore
	__length = 1;
	///@ignore
	__stretch = false
	///@ignore
	__disabled = false;
	///@ignore
	__channels = []
	///@ignore
	__holder = _context

	///@ignore
	static build = function() {
		var _keyframe = sequence_keyframe_new(__type);
		_keyframe.channels = array_map(__channels, intern_sequence_builder);
		_keyframe.disabled = __disabled;
		_keyframe.frame = __frame;
		_keyframe.length = __length;
		_keyframe.stretch = __stretch;
		return _keyframe
	}
}
///@desc creates a new keyframe wrapper for a Real track wrapper
///@param {struct.RealTrackWrapper} _context 
///@returns {struct.RealKeyframe}
function RealKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_real;
	static add_keyframe_data = function() {
		var _ret = new RealProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	/// @returns {struct.RealTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a Graphic track wrapper
///@param {struct.GraphicTrackWrapper} _context 
///@returns {struct.GraphicKeyframe}
function GraphicKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_graphic;
	static add_keyframe_data = function() {
		var _ret = new GraphicProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	///@returns {struct.GraphicTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for an Audio track wrapper
///@param {struct.AudioTrackWrapper} _context 
///@returns {struct.AudioKeyframe}
function AudioKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_audio;
	static add_keyframe_data = function() {
		var _ret = new AudioProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	
	///@returns {struct.AudioTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a Sequence track wrapper
///@param {struct.SequenceTrackWrapper} _context 
///@returns {struct.SequenceKeyframe}
function SequenceKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_sequence;
	static add_keyframe_data = function() {
		var _ret = new SequenceProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	///@returns {struct.SequenceTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a Bool track wrapper
///@param {struct.BoolTrackWrapper} _context 
///@returns {struct.BoolKeyframe}
function BoolKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_bool
	static add_keyframe_data = function() {
		var _ret = new BoolProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	///@returns {struct.BoolTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a SpriteFrame track wrapper
///@param {struct.SpriteFrameTrackWrapper} _context 
///@returns {struct.SpriteframeKeyframe}
function SpriteframeKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_spriteframes
	static add_keyframe_data = function() {
		var _ret = new SpriteframeProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	///@returns {struct.SpriteFrameTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a String track wrapper
///@param {struct.StringTrackWrapper} _context 
///@returns {struct.StringKeyframe}
function StringKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_string
	static add_keyframe_data = function() {
		var _ret = new StringProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	///@returns {struct.StringTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a Color track wrapper
///@param {struct.ColorTrackWrapper} _context 
///@returns {struct.ColorKeyframe}
function ColorKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_color;
	static add_keyframe_data = function() {
		var _ret = new ColorProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	///@returns {struct.ColorTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a Colour track wrapper
///@param {struct.ColourTrackWrapper} _context 
///@returns {struct.ColourKeyframe}
function ColourKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_colour;
	static add_keyframe_data = function() {
		var _ret = new ColourProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	
	///@returns {struct.ColourTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for an Instance track wrapper
///@param {struct.InstanceTrackWrapper} _context 
///@returns {struct.InstanceKeyframe}
function InstanceKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_instance
	static add_keyframe_data = function() {
		var _ret = new InstanceProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	
	///@returns {struct.InstanceTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a Text track wrapper
///@param {struct.TextTrackWrapper} _context 
///@returns {struct.TextKeyframe}
function TextKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_text
	static add_keyframe_data = function() {
		var _ret = new TextProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
///@desc creates a new keyframe wrapper for a Particles track wrapper
///@param {struct.ParticleTrackWrapper} _context 
///@returns {struct.ParticlesKeyframe}
function ParticlesKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_particlesystem;
	static add_keyframe_data = function() {
		var _ret = new ParticleSystemProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}

	///@return {struct.ParticleTrackWrapper}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
/// @desc creates a new keyframe wrapper for a the Moment track of the Sequence builder
/// @desc Function Description
/// @param {struct.SequenceBuilder} _context Description
function MomentKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_moment;
	static add_keyframe_data = function() {
		var _ret = new MomentProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	///@return {struct.SequenceBuilder}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}
/// @desc creates a new keyframe wrapper for a the MessageEvent track of the Sequence builder
/// @desc Function Description
/// @param {struct.SequenceBuilder} _context Description
function MessageKeyframe(_context) : KeyframeWrapper(_context) constructor {
	__type = seqtracktype_message;
	static add_keyframe_data = function() {
		var _ret = new MessageProperty(self)
		array_push(__channels, _ret)
		return _ret;
	}
	///@return {struct.SequenceBuilder}
	static finalize = function() {
		channel_id = 0;
		return __holder;
	}
	static frame = function(_frame) {
		__frame = _frame
		return self
	}
	static length = function(_length) {
		__length = _length
		return self
	}
	static stretch = function(_should_stretch) {
		__stretch = _should_stretch
		return self
	}
	static disabled = function(_should_disable) {
		__disabled = _should_disable
		return self;
	}
}