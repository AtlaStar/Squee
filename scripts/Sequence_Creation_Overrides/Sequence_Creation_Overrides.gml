// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro __INTERN_LAYER_SEQUENCE_CREATE__ layer_sequence_create




//TO-DO rework the innards
///@returns {Id.SequenceElement}
function __squee_ui_layer_sequence_create(layer_id, x, y, sequence_id) {
	if(!is_struct(sequence_id)) {
		sequence_id = sequence_get(sequence_id)	
	}
	var _ret = __INTERN_LAYER_SEQUENCE_CREATE__(layer_id, x, y, sequence_id)
	return _ret
}
// Feather disable once GM2017
#macro layer_sequence_create __squee_ui_layer_sequence_create
