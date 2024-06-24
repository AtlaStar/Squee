/**
 * A keyframe data constructor type, defined by each wrapper type for proper interfacing
 * in order to return back to the calling KeyframeWrapper context.
 */
 
 //we throw a default in so feather knows that the function will certainly be called
 //and that the channel_id property won't be undefined
function DataProperty(_context) constructor {
	
	 ///@ignore
	static channel = function() {
		return 	self.__data_holder.channel_id++
	}
	
	///@ignore
	__data_holder = _context;
	///@ignore
	__is_frozen = false;
	///@ignore
	__channel = channel();
	
}

/**
 * @param {struct.RealKeyframe} _context Description
 */
function RealProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__curve = undefined;
	///@ignore
	__value = undefined;

	/// Assigns an animation curve to this real type keyframe
	///@param {struct.AnimCurve} _curve the animation curve to assign
	static curve = function(_curve) {
		if self.__is_frozen
			return self;
		self.__curve = _curve;
		return self
	}
		
	/// Assigns a real value to this real type keyframe
	///@param {Real} _value the real value to assign
	static value = function(_value) {
		if self.__is_frozen
			return self;
		__value = _value;
		return self
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_real()
		__data.channel = __channel
		__data.curve = __curve;
		__data.value = __value;
		return __data;
	}
	
	///@returns {struct.RealKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function GraphicProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__sprite_index = undefined;
	/**
	* Assigns a sprite index to this graphic type keyframe
	* @param {asset.GMSprite} _idx The sprite index to assign
	*/
	static sprite = function(_idx) {
		if __is_frozen
			return self;
		__sprite_index = _idx
		return self;
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_graphic();
		__data.channel = __channel
		__data.spriteIndex = __sprite_index;
		return __data;
	}
	
	///@returns {struct.GraphicKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function AudioProperty(_context) : DataProperty(_context) constructor {
	
	///@ignore
	__emitter_index = undefined;
	///@ignore
	__playback_mode = undefined;
	///@ignore
	__sound_index = undefined;
	/**
		* Assigns an emitter to use for this audio typed keyframe
		* @param {Id.AudioEmitter} _emitter Description
		*/
	static emitter = function(_emitter) {
		if __is_frozen
			return self;
		__emitter_index = _emitter;
		return self;
	}
		
		
	/**
		* Assigns the playback mode to use for this audio typed keyframe
		* @param {Constant.SequenceAudioKey} _mode Description
		*/
	static playback_mode = function(_mode) {
		if __is_frozen
			return self;
		__playback_mode = _mode;
		return self;	
	}
		
	/**
		* Assigns the sound to use for this audio typed keyframe
		* @param {asset.GMSound} _index Description
		*/
	static sound = function(_index) {
		if __is_frozen
			return self;
		__sound_index = _index
		return self;	
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_audio();
		__data.channel = __channel
		__data.emitterIndex = __emitter_index
		__data.playbackMode = __playback_mode;
		__data.soundIndex = __sound_index;
		return __data;
	}
	
	///@returns {struct.AudioKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function SequenceProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__sequence = undefined;
	/**
		* Function Description
		* @param {struct.Sequence} _seq Description
		*/
	static sequence = function(_seq) {
		if __is_frozen
			return self;
		__sequence = _seq
		return self;
	}
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_sequence()
		__data.channel = __channel
		__data.sequence = __sequence
		return __data;
	}
	///@returns {struct.SequenceKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function BoolProperty(_context) : DataProperty(_context) constructor {

	///@ignore
	__value = undefined;
	/**
		* Assings a value to this bool typed keyframe
		* @param {bool} _val Description
		*/
	static bool = function(_val) {
		if __is_frozen
			return self;
		__value = _val
		return self;
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_bool()
		__data.channel = __channel
		__data.value = __value;
		return __data
	}

	///@returns {struct.BoolKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function SpriteframeProperty(_context) : DataProperty(_context) constructor {

	///@ignore
	__image_index = undefined;
	
	static index = function(_image_index) {
		if __is_frozen
			return self;
		__image_index = _image_index
		return self
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_spriteframes()
		__data.channel = __channel;
		__data.imageIndex = __image_index
		return __data;
	}
	///@returns {struct.SpriteframeKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function StringProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__value = undefined;
	
	static string = function(_string) {
		if __is_frozen
			return self;
		__value = _string
		return self;	
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_string()
		__data.channel = __channel;
		__data.value = __value;
		return __data;
	}
	///@returns {struct.StringKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function ColorProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__color = undefined;

		
	static color = function(_color) {
		if __is_frozen
			return self;
		__color = _color
		return self;
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_color()
		__data.channel = __channel;
		__data.color = __color;
		return __data;
	}

	///@returns {struct.ColorKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function ColourProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__colour = undefined;
	
	static color = function(_color) {
		if __is_frozen
			return self;
		__colour = _color
		return self;
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_color()
		__data.channel = __channel;
		__data.colour = __colour;
		return __data;
	}
	///@returns {struct.ColourKeyframe}
	static finalize = function() {
		return __data_holder;
	}
}

function InstanceProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__object_index = undefined;
		
	static object = function(_index) {
		if __is_frozen
			return self;
		__object_index = _index
		return self;	
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_instance()
		__data.channel = __channel;
		__data.objectIndex = __object_index;
		return __data;
	}
	
	///@returns {struct.InstanceKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

function TextProperty(_context) : DataProperty(_context) constructor {

	///@ignore
	__text = undefined;
	///@ignore
	__wrap = undefined;
	///@ignore
	__font = undefined;
	///@ignore
	__align_h = undefined;
	///@ignore
	__align_v = undefined;
	
	static text = function(_t) {
		if __is_frozen
			return self;
		__text = _t;
		return self;
	}
		
	static wrap = function(_bool) {
		if __is_frozen
			return self;
		__wrap = _bool;	
	}
		
	static font = function(_font_asset) {
		if __is_frozen
			return self;
		__font = _font_asset;	
	}
		
	static align_vertical = function (_v) {
		if __is_frozen
			return self;
		__align_v= _v;
		return self;
	}
	static align_horizontal = function(_h) {
		if __is_frozen
			return self;
		__align_h = _h;	
		return self;
	}
	
	///@ignore
	static build = function() {
		var	__data = sequence_keyframedata_new_text();
		__data.channel = __channel;
		__data.alignmentH = __align_h;
		__data.alignmentV = __align_v;
		__data.text	 = __text;
		__data.font = __font;
		__data.wrap	 = __wrap
		return __data;
	}
	///@returns {struct.TextKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

/**
 * Function Description
 * @param {struct.ParticlesKeyframe} _context Description
 */
function ParticleSystemProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__ps_index = undefined;
	
	static index = function(_particle_system) {
		if __is_frozen
			return self;
		__ps_index = _particle_system;
		return self;
	}
	
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_particlesystem();
		__data.channel = __channel;
		__data.particleSystemIndex = __ps_index;
		return __data;
	}
	///@returns {struct.ParticlesKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

/// @desc Function Description
/// @param {struct.MomentKeyframe} _context Description
function MomentProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__event = undefined

	static event = function(_ev) {
		if __is_frozen
			return self
		__event = _ev
		return self;
	}
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_moment();
		__data.channel = __channel;
		__data.event = __event
		return __data;
	}
	///@returns {struct.MomentKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}

/// @desc Function Description
/// @param {struct.MessageKeyframe} _context Description
function MessageProperty(_context) : DataProperty(_context) constructor {
	///@ignore
	__events = undefined
	
	
	static events = function(_ev) {
		if __is_frozen
			return self
		__event = _ev
		return self;
	}
	///@ignore
	static build = function() {
		var __data = sequence_keyframedata_new_message();
		__data.channel = __channel;
		__data.events = __events;
		return __data;
	}
	///@returns {struct.MessageKeyframe}
	static finalize = function() {
		return __data_holder;
	}
	static freeze = function() {
		__is_frozen = true;
		return finalize();
	}
}