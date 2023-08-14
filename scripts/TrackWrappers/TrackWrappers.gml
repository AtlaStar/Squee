/*
	Here be a load of stuff to ensure that each track wrapper returns a proper keyframe type based on the track type,
	along with things to copy functions that would otherwise stay in a base class but would no longer return the proper 'self'
	due to feather binding the return type as the type where it is declared, with no deduction when it is returning a child
	type. This means that the `name` setting function would return a TrackWrapper base if it isn't duplicated per child.
*/

#macro TWFUNCS_NAME 	static name = function(_name) {		\
							__name = _name;					\
							return self;					\
						}

#macro TWFUNCS_TYPE		static type = function(_type) {		\
							__type = _type					\
							return self;					\
						}

#macro TWFUNCS	TWFUNCS_NAME \
				TWFUNCS_TYPE						

/// @desc Function Description
/// @param {constant.SequenceTrackType} [_type] Description
/// @ignore
function TrackWrapper(_type = seqtracktype_empty) constructor {
	///@ignore
	__name = "";
	///@ignore
	__type = _type
	///@ignore
	__tracks = empty_tracks_array();
	///@ignore
	__keyframes = empty_keyframe_array();
	
	/// @ignore
	/// @param {struct.TrackWrapper} _track Description
	static intern_add_track = function(_track) {
		array_push(__tracks, _track)
	}

	/// @desc Function Description
	/// @param {struct.trackwrapper} _track Description
	static add_track = function(_track) {
		intern_add_track(_track)
		return self
	}
	///@ignore
	static build = function() {
		var _track = sequence_track_new(__type)
		_track.tracks = array_map(__tracks, intern_sequence_builder)
		_track.keyframes = array_map(__keyframes, intern_sequence_builder)
		_track.name = __name;
		_track.visible = true;
		return _track;
	}
}

/// @desc Creates a new fluent wrapper for a Real Track
/// @returns {struct.RealTrackWrapper}
function RealTrackWrapper() : TrackWrapper(seqtracktype_real) constructor {
	///@desc Adds a keyframe to this RealTrack type
	///@returns {struct.RealKeyframe}
	static add_keyframe = function() {
		var _keyframe = new RealKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe
	}
	TWFUNCS_NAME
}

///@ignore
///@returns {struct.BuiltinRealWrapper}
function BuiltinRealWrapper() : RealTrackWrapper() constructor {}
/// @desc Creates a new fluent wrapper for an Origin Real Track
///@returns {struct.OriginTrackWrapper}
function OriginTrackWrapper() : BuiltinRealWrapper() constructor {
	__name = "origin"
}

/// @desc Creates a new fluent wrapper for a Position Real Track
/// @returns {struct.PositionTrackWrapper}
function PositionTrackWrapper() : BuiltinRealWrapper() constructor {
	__name = "position"
}

/// @desc Creates a new fluent wrapper for a Rotation Real Track
/// @returns {struct.RotationTrackWrapper}
function RotationTrackWrapper() : BuiltinRealWrapper() constructor {
	__name = "rotation"
}

/// @desc Creates a new fluent wrapper for a Scale Real Track
/// @returns {struct.ScaleTrackWrapper}
function ScaleTrackWrapper() : BuiltinRealWrapper() constructor {
	__name = "scale"
}

/// @desc Creates a new fluent wrapper for a Boolean Track
///@returns {struct.BoolTrackWrapper}
function BoolTrackWrapper() : TrackWrapper(seqtracktype_bool) constructor {
	///@desc add a keyframe to this Bool track type
	static add_keyframe = function() {
		var _keyframe = new BoolKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe
	}
	TWFUNCS_NAME
}
/// @desc Creates a new fluent wrapper for a String Track
///@returns {struct.StringTrackWrapper}
function StringTrackWrapper(): TrackWrapper(seqtracktype_string) constructor {
	///@desc add a keyframe to this String track type
	static add_keyframe = function() {
		var _keyframe = new StringKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe
	}
	TWFUNCS_NAME
}
///@ignore
///@returns {struct.AssetTrackWrapper}
function AssetHolderTrackWrapper(_type) : TrackWrapper(_type) constructor{
}

/// @desc Creates a new fluent wrapper for a Group Track
///@returns {struct.GroupTrackWrapper}
function GroupTrackWrapper() : AssetHolderTrackWrapper(seqtracktype_group) constructor {
	/// @desc Adds a track to this Asset holding track
	/// @param {struct.AssetTrackWrapper| struct.ClipmaskTrackWrapper| struct.BuiltinRealWrapper} _track Description
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
	TWFUNCS_NAME
}

/// @desc Creates a new fluent wrapper for a Sequence Track
///@returns {struct.SequenceTrackWrapper}
function SequenceTrackWrapper() : AssetHolderTrackWrapper(seqtracktype_sequence) constructor {
	/// @desc Adds a track to this Asset holding track
	/// @param {struct.AssetTrackWrapper| struct.ClipmaskTrackWrapper| struct.BuiltinRealWrapper} _track Description
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
	///@desc Adds a keyframe to this SequenceTrack type
	static add_keyframe = function() {
		var _keyframe = new SequenceKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe;
	}
	TWFUNCS_NAME
}

///@ignore
function AudioParamsTrackWrapper(): RealTrackWrapper() constructor {}

/// @desc Creates a new fluent wrapper for a Pitch Audio param Track
function PitchTrackWrapper() : AudioParamsTrackWrapper() constructor{
	__name = "pitch"	
}
/// @desc Creates a new fluent wrapper for a Gain Audio param Track
function GainTrackWrapper() : AudioParamsTrackWrapper() constructor {
	__name = "gain"	
}

/// @desc Creates a new fluent wrapper for an Audio Track
///@returns {struct.AudioTrackWrapper}
function AudioTrackWrapper() : AssetHolderTrackWrapper(seqtracktype_audio) constructor {
	/// @desc Adds a track to this Asset holding track
	/// @param {struct.AssetTrackWrapper| struct.ClipmaskTrackWrapper| struct.PositionTrackWrapper| struct.RotationTrackWrapper| struct.AudioParamsTrackWrapper} _track Description
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
	///@desc Adds a keyframe to this AudioTrack type
	static add_keyframe =  function() {
		var _keyframe = new AudioKeyframe(self);
		array_push(__keyframes, _keyframe)
		return _keyframe;
	}
	TWFUNCS_NAME
}
///@ignore
function ColoredAssetHolderTrackWrapper(_type) : AssetHolderTrackWrapper(_type) constructor {
}

/// @desc Creates a new fluent wrapper for a Particle Track
///		currently broken due to upstream Gamemaker bug
///@returns {struct.ParticleTrackWrapper}
function ParticleTrackWrapper() : ColoredAssetHolderTrackWrapper(seqtracktype_particlesystem) constructor {
	/// @desc Adds a track to this Asset holding track
	/// @param {struct.AssetTrackWrapper| struct.ClipmaskTrackWrapper| struct.BuiltinRealWrapper| struct.ColorableTrackWrapper} _track Description
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
	///@desc Adds a keyframe to this ParticleTrack type
	static add_keyframe = function() {
		var _keyframe = new ParticlesKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe;
	}
	TWFUNCS_NAME
}

/// @ignore
function SpritableParamTrackWrapper() : RealTrackWrapper() constructor {}

/// @desc Creates a new fluent wrapper for an Image Speed param Track
function ImageSpeedTrackWrapper() : SpritableParamTrackWrapper() constructor {
	__name = "image_speed"	
}
/// @desc Creates a new fluent wrapper for an Image Index param Track
function ImageIndexTrackWrapper() : SpritableParamTrackWrapper() constructor {
	__name = "image_index"
}

/// @desc Creates a new fluent wrapper for an Instance Track
///@returns {struct.InstanceTrackWrapper}
function InstanceTrackWrapper() : ColoredAssetHolderTrackWrapper(seqtracktype_instance) constructor {
	/// @desc Adds a track to this Asset holding track
	/// @param {struct.AssetTrackWrapper| struct.ClipmaskTrackWrapper| struct.BuiltinRealWrapper| struct.ColorableTrackWrapper| struct.SpritableParamTrackWrapper} _track Description
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
	///@desc Adds a keyframe to this InstanceTrack type
	static add_keyframe = function() {
		var _keyframe = new InstanceKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe;
	}
	TWFUNCS_NAME
}

/// @desc Creates a new fluent wrapper for a Graphic Track
///@returns {struct.GraphicTrackWrapper}
function GraphicTrackWrapper() : ColoredAssetHolderTrackWrapper(seqtracktype_graphic) constructor {
	/// @desc Adds a track to this Asset holding track
	/// @param {struct.AssetTrackWrapper| struct.ClipmaskTrackWrapper| struct.BuiltinRealWrapper| struct.ColorableTrackWrapper| struct.SpritableParamTrackWrapper} _track Description
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
	///@desc Adds a keyframe to this GraphicTrack type
	static add_keyframe = function() {
		var _keyframe = new GraphicKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe;
	}
	TWFUNCS_NAME
}

///@ignore
function TextParamsTrackWrapper() : RealTrackWrapper() constructor{}

/// @desc Creates a new fluent wrapper for a Line Spacing Text param track
/// @returns {struct.LineSpacingTrackWrapper} 
function LineSpacingTrackWrapper() : TextParamsTrackWrapper() constructor {
	__name = "lineSpacing"	
}
/// @desc Creates a new fluent wrapper for a Character Spacing Text param track
/// @returns {struct.CharacterSpacingTrackWrapper} 
function CharacterSpacingTrackWrapper() : TextParamsTrackWrapper() constructor {
	__name = "characterSpacing"	
}
/// @desc Creates a new fluent wrapper for a Paragraph Spacing Text param track
/// @returns {struct.ParagraphSpacingTrackWrapper} 
function ParagraphSpacingTrackWrapper() : TextParamsTrackWrapper() constructor {
	__name = "paragraphSpacing"	
}
/// @desc Creates a new fluent wrapper for a Textbox Frame Size param track
/// @returns {struct.FrameSizeTrackWrapper} 
function FrameSizeTrackWrapper() : TextParamsTrackWrapper() constructor {
	__name = "frameSize"
}

/// @desc Creates a new fluent wrapper for a Text track wrapper
/// @returns {struct.TextTrackWrapper}
function TextTrackWrapper() : ColoredAssetHolderTrackWrapper(seqtracktype_text) constructor {
	/// @desc Adds a track to this Asset holding track
	/// @param {struct.AssetTrackWrapper| struct.ClipmaskTrackWrapper| struct.BuiltinRealWrapper| struct.ColorableTrackWrapper| struct.TextParamsTrackWrapper} _track Description
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
	///@desc add a keyframe to this Text track type
	static add_keyframe = function() {
		var _keyframe = new TextKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe
	}
	TWFUNCS_NAME
}
/// @desc Creates a new fluent wrapper for a Clipmask Track wrapper
///@returns {struct.ClipmaskTrackWrapper}
function ClipmaskTrackWrapper() : TrackWrapper(seqtracktype_clipmask) constructor {
	///@param {struct.ClipmaskSubtrackWrapper| struct.RotationTrackWrapper| struct.PositionTrackWrapper} _track
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
	TWFUNCS_NAME
}

///@ignore
///@returns {struct.ClipmaskSubtrackWrapper}
function ClipmaskSubtrackWrapper(_type) : TrackWrapper(_type) constructor{
	///@param {struct.AssetHolderTrack| struct.RotationTrackWrapper| struct.PositionTrackWrapper} _track
	static add_track = function(_track) {
		intern_add_track(_track)
		return self;
	}
}
/// @desc Creates a new fluent wrapper for a Clipmask Mask Track wrapper
///@returns {struct.ClipmaskMaskTrackWrapper}
function ClipmaskMaskTrackWrapper() : ClipmaskSubtrackWrapper(seqtracktype_clipmask_mask) constructor {
	__name = "mask"
}
/// @desc Creates a new fluent wrapper for a Clipmask Subject Track wrapper
///@returns {struct.ClipmaskSubjectTrackWrapper}
function ClipmaskSubjectTrackWrapper() : ClipmaskSubtrackWrapper(seqtracktype_clipmask_subject) constructor {
	__name = "subject"
}

/// @ignore
///@returns {struct.ColorableTrackWrapper}
function ColorableTrackWrapper(_type) : TrackWrapper(_type) constructor{}

/// @desc Creates a new fluent wrapper for a Color Track wrapper
///@returns {struct.ColorTrackWrapper}
function ColorTrackWrapper() : ColorableTrackWrapper(seqtracktype_color) constructor {
	///@desc add a keyframe to this Color track type
	static add_keyframe = function() {
		var _keyframe = new ColorKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe
	}
	TWFUNCS_NAME
}
/// @desc Creates a new fluent wrapper for a Colour Track wrapper
///@returns {struct.ColourTrackWrapper}
function ColourTrackWrapper() : ColorableTrackWrapper(seqtracktype_colour) constructor {
	///@desc add a keyframe to this Colour track type
	static add_keyframe = function() {
		var _keyframe = new ColourKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe
	}
	TWFUNCS_NAME
}

/// @desc Creates a new fluent wrapper for a Spriteframe Track wrapper
///@returns {struct.SpriteFrameTrackWrapper}
function SpriteFrameTrackWrapper() : TrackWrapper(seqtracktype_spriteframes) constructor {
	///@desc add a keyframe to this SpriteFrame track type
	static add_keyframe = function() {
		var _keyframe = new SpriteframeKeyframe(self)
		array_push(__keyframes, _keyframe)
		return _keyframe
	}
	TWFUNCS_NAME
}

