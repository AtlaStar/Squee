
seq = new SequenceBuilder("my fleunt constructed sequence")
	.loopmode_repeat()
	.add_track(
		new SequenceTrackWrapper()
		.add_keyframe()
			.frame(0)
			.length(300)
			.add_keyframe_data()
				.sequence(sequence_get(Sequence3))
				.finalize()
			.finalize()
		.name("sequence_3_track")
	).length(300)
	.build()

var _seq = sequence_create();
_seq.name = "my sequence"
_seq.length = 300;
_seq.loopmode = seqplay_loop
var _track = sequence_track_new(seqtracktype_sequence)
var _keyframe = sequence_keyframe_new(seqtracktype_sequence)
_keyframe.frame = 0;
_keyframe.length = 300;
var _data = sequence_keyframedata_new_sequence()
_data.channel = 0;
_data.sequence = sequence_get(Sequence3);
_keyframe.channels = [_data]
_track.keyframes = [_keyframe]
_seq.tracks = [_track]

var _elem = layer_sequence_create("Assets_1", Object1.x, Object1.y, seq)

function test_func(){
	show_debug_message(prop)
}

var _m1 = method(undefined, test_func)
var _m2 = method(undefined, test_func)

var _s1 = {
	prop: 1	
}
var _s2 = {
	prop: "string this time"	
}

static_set(static_get(test_func), _s1)
static_set(static_get(_m2), _s2)

_m1()
_m2()
