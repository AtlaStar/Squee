// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// Feather disable once GM2017

function SqueeUI() 
{
	static layer_gui_layer_scripts = {}
	static layer_gui_layer = {}
	static layer_gui_layer_view = {};
}
SqueeUI();


function layer_gui_ini_layer() {}
layer_gui_ini_layer.depth = 10000;

function layer_gui_get_new_layer_depth() {
	return layer_gui_ini_layer.depth--;
}

function layer_gui_layer_bind_view(layer_id, view) {
	SqueeUI.layer_gui_layer_view[$ layer_id] = view;
}

/**
 * Function Description
 * @param {string} _layer_id Description
 * @returns {id.Layer} Description
 */
function layer_gui_get_or_create_layer(_layer_id) {
	static context = static_get(SqueeUI)
	var _layers = context.layer_gui_layer
	var _layer = self[$ _layer_id]

	if(!_layer) {
		var _exists = layer_exists(_layer_id)
		if _exists {
			_layer = layer_get_id(_layer_id)	
		} else {
			_layer = layer_create(layer_gui_get_new_layer_depth(), _layer_id)
		}
		_layers[$ _layer_id] = _layer
	}
	return _layer;
}


/**
 * Function Description
 * @param {id.Layer} _dummy Description
 */
function InnerLayerHolder(_dummy) constructor {
	layer_id = _dummy;	
}

function squee_cache() {}
squee_cache.surfaces = {}
static_set(squee_cache.surfaces, {
	create:	function(layer) {
		self[$ layer] = surface_create(display_get_gui_width(), display_get_gui_height())
		return self[$ layer]
	},
	get: function(layer) {
			return self[$ layer]
	}
})
/// @desc Function Description
/// @param {string} layer_id Description
/// @param {real} x Description
/// @param {real} y Description
/// @param {asset.GMSequence} sequence Description
/// @returns {id.SequenceElement} Description
/// @self {Object1}

function layer_gui_sequence_create(layer_id, x, y, sequence) {
	
	function layer_func() {
		var surf = squee_cache.surfaces.get(layer)
		
		if !surface_exists(surf) {
			surf = squee_cache.surfaces.create(layer)
		}
		if event_type == ev_draw {
			if event_number == ev_draw_normal {
				surface_set_target(surf)
			} else if event_number == ev_gui {
				draw_surface(surf, 0,0)
			} else if event_number == ev_draw_begin {
				surface_resize(surf, display_get_gui_width(), display_get_gui_height())
			}
		}
	}

	function layer_end_draw() {
		var surf = squee_cache.surfaces.get(layer)
		if event_type == ev_draw {
			if event_number == ev_draw_normal {
				surface_reset_target()
			} else if event_number == ev_gui {
				if surface_exists(surf)
					surface_free(surf)	
			}
		}
	}
	
	var _layer = layer_gui_get_or_create_layer(layer_id)
	
	if is_undefined(squee_cache.surfaces.get(_layer))
		squee_cache.surfaces.create(_layer)

	layer_script_begin(layer_id, layer_func)
	layer_script_end(layer_id, layer_end_draw)

	return layer_sequence_create(layer_id, x, y, sequence)
}
