function TsTimelineFrames() constructor {
	static timesource = time_source_create(time_source_game, 0, time_source_units_frames, function() {});
	
	static enqueue_moment = function(_frame, _callback, _args = []) {
		_frame = _frame + 1;
		if !__frozen {
			array_push(__children_ts, time_source_create(timesource, _frame, time_source_units_frames, _callback, _args))
			if _frame > __final_moment
				__final_moment = _frame;
		}
		return self;
	}

	static pause = function() {
		time_source_pause(timesource)
		return self;
	}
	static start = function() {
		// Feather disable once GM1009
		if time_source_get_parent(timesource) == time_source_game || __frozen {
			time_source_start(timesource);
		}
		return self;
	}
	
	static reset = function() {
		array_foreach(__children_ts, function(_ts) {
			time_source_reset(_ts)
		})
		return self;
	}
	
	static destroy = function() {
		time_source_destroy(timesource, true);
	}
	
	static finalize = function(_end_frame = undefined) {
		__frozen = true;
		__final_moment = _end_frame ?? __final_moment
		return self;
	}
	
	static set_repeat = function(_val) {
		__should_repeat = true;
		return self;
	}
	
	static set_end_frame = function(_val) {
		__final_moment = _val;
		return self;
	}
	
	var tick = function() {
		if __current_frame >= __final_moment {
			reset();
			if __should_repeat {
				time_source_start(timesource);
				__current_frame = 0;
			}
		} else
			__current_frame++
	}

	__should_repeat = false;
	__final_moment = 0;
	__current_frame = 0;
	__frozen = false;
	__children_ts = []
	self.timesource = time_source_create(timesource, 0, time_source_units_frames, tick, [], -1)
}