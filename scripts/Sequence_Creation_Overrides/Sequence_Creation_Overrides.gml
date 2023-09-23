// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro __INTERN_LAYER_SEQUENCE_CREATE__ layer_sequence_create



///@returns {Id.SequenceElement}
function __squee_ui_layer_sequence_create(layer_id, x, y, sequence_id) {
	if(!is_struct(sequence_id)) {
		sequence_id = sequence_get(sequence_id)	
	}

	var _event = sequence_id.event_step;
	//we keep at this scope so we can decide whether we need to shim our static into the sequence instances static chain if the feature is enabled.
	if squee_is_enabled(event_step_replacement) {
		if !squee_is_enabled(_event) {
			if is_callable(_event) {
				__intern_squee_add_sequence_step_event(sequence_id, _event)
			} else {
				__intern_squee_add_sequence_step_event(sequence_id)
			}
		}
		var _new_event = method(undefined, event_step_replacement)
		sequence_id.event_step = _new_event
	}

	var _ret = __INTERN_LAYER_SEQUENCE_CREATE__(layer_id, x, y, sequence_id)
	var _inst = layer_sequence_get_instance(_ret)
	
	_inst.original_step_event = sequence_id.original_step_event
	_inst.flatten_complete = false;
	
	if squee_is_enabled(squee_auto_replace_anchors) {
		with(_inst) {
			squee_auto_replace_anchors();
		}
	}
	return _ret
}
// Feather disable once GM2017
#macro layer_sequence_create __squee_ui_layer_sequence_create