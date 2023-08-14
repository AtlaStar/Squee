
// feather disable GM1045
/// @desc Returns a keyframe data struct for the internal RealTrack type
/// @pure
/// @returns {struct.RealTrack} 
function sequence_keyframedata_new_real() {
	return sequence_keyframedata_new(seqtracktype_real)
}

/// @desc Returns a keyframe data struct for the internal GraphicTrack type
/// @pure
/// @returns {struct.GraphicTrack}
function sequence_keyframedata_new_graphic() {
	return sequence_keyframedata_new(seqtracktype_graphic)	
}
/// @desc Returns a keyframe data struct for the internal AudioTrack type
/// @pure
/// @returns {struct.AudioTrack} 
function sequence_keyframedata_new_audio() {
	return sequence_keyframedata_new(seqtracktype_audio)
}
/// @desc Returns a keyframe data struct for the internal SequenceTrack type
/// @pure
/// @returns {struct.SequenceTrack} 
function sequence_keyframedata_new_sequence() {
	return sequence_keyframedata_new(seqtracktype_sequence)
}
/// @desc Returns a keyframe data struct for the internal BoolTrack type
/// @pure
/// @returns {struct.BoolTrack} 
function sequence_keyframedata_new_bool() {
	return sequence_keyframedata_new(seqtracktype_bool)
}
/// @desc Returns a keyframe data struct for the internal SpriteTrack type
/// @pure
/// @returns {struct.SpriteTrack} 
function sequence_keyframedata_new_spriteframes() {
	return sequence_keyframedata_new(seqtracktype_spriteframes)
}
/// @desc Returns a keyframe data struct for the internal StringTrack type
/// @pure
/// @returns {struct.StringTrack} 
function sequence_keyframedata_new_string() {
	return sequence_keyframedata_new(seqtracktype_string)
}
/// @desc Returns a keyframe data struct for the internal ColorTrack type
/// @pure
/// @returns {struct.ColorTrack} 
function sequence_keyframedata_new_color() {
	return sequence_keyframedata_new(seqtracktype_color)
}
/// @desc Returns a keyframe data struct for the internal ColourTrack type
/// @pure
/// @returns {struct.ColourTrack} 
function sequence_keyframedata_new_colour() {
	return sequence_keyframedata_new(seqtracktype_colour)
}
/// @desc Returns a keyframe data struct for the internal InstanceTrack type
/// @pure
/// @returns {struct.InstanceTrack}
function sequence_keyframedata_new_instance() {
	return sequence_keyframedata_new(seqtracktype_instance)
}
/// @desc Returns a keyframe data struct for the internal TextTrack type
/// @pure
/// @returns {struct.TextTrack} Description
function sequence_keyframedata_new_text() {
	return sequence_keyframedata_new(seqtracktype_text)	
}

/// @desc Returns a keyframe data struct for the internal KeyChannel type, but this isn't documented in the GML spec and just sort of
///		exists for completions sake...should probably remove or ignore
/// @pure
/// @returns {struct.KeyChannel} 
function sequence_keyframedata_new_empty() {
	return sequence_keyframedata_new(seqtracktype_empty)	
}


/// @desc Returns a keyframe data struct for the internal ParticlesTrack type; currently an upstream bug prevents the use of this function
/// @pure
/// @returns {struct.ParticlesTrack} 
function sequence_keyframedata_new_particlesystem() {
	return sequence_keyframedata_new(seqtracktype_particlesystem)
}

/// @desc Returns a keyframe data struct for the internal Moment type
/// @pure
/// @returns {struct.Moment} Description
function sequence_keyframedata_new_moment() {
	return sequence_keyframedata_new(seqtracktype_moment)
}


/// @desc Returns a keyframe data struct for the internal MessageEvent type
/// @pure
/// @returns {struct.MessageEvent} Description
function sequence_keyframedata_new_message() {
	return sequence_keyframedata_new(seqtracktype_message)
}

/// @desc a function to return an empty keyframe wrapper array to keep feather happy
/// @pure
/// @self {undefined}
/// @returns {array<struct.KeyframeWrapper>} Description
function empty_keyframe_array() {
	return []
}
/// @desc a function to return an empty track wrapper array to keep feather happy
/// @pure
/// @self {undefined}
/// @returns {array<struct.TrackWrapper>} Description
function empty_tracks_array() {
	return []
}

// feather enable GM1045