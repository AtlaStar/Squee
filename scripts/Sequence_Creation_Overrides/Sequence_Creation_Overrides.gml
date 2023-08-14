// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro __INTERN_LAYER_SEQUENCE_CREATE__ layer_sequence_create

function __squee_ui_layer_sequence_create(layer_id, x, y, sequence_id) {
	if(!is_struct(sequence_id)) {
		sequence_id = sequence_get(sequence_id)	
	}
	
	
	//we keep at this scope so we can decide whether we need to shim our static into the sequence instances static chain if the feature is enabled.
	var _static = undefined;
	
	if asset_has_tags(event_step_replacement, "SqueeUIEnabledFeature", asset_script) {
		if !asset_has_tags(sequence_id.event_step, "SqueeUIReplacementFunction", asset_script) {
			if is_callable(sequence_id.event_step) {
				var _old = sequence_id.event_step;
				_static = { original_step_event: _old }
			} else {
				_static = { original_step_event: function(){
						show_debug_message("invoking inserted default shim")
					} 
				}
			}
		}
		sequence_id.event_step = method(undefined , event_step_replacement)
	}

	var _ret = __INTERN_LAYER_SEQUENCE_CREATE__(layer_id, x, y, sequence_id)
	
	if _static {
		var _inst = layer_sequence_get_instance(_ret)
		static_set(_static, static_get(_inst))
		static_set(_inst, _static)
	}
	return _ret
}
// Feather disable once GM2017
#macro layer_sequence_create __squee_ui_layer_sequence_create

function event_step_replacement() {
	static completed = false
	if !completed {
		sequence_instance_flatten();
		completed = true;
	}
	original_step_event();
}

asset_add_tags(event_step_replacement, ["SqueeUIEnabledFeature","SqueeUIReplacementFunction"], asset_script)