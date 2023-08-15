// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// Feather disable once GM2017
function SqueeUI() 
{
	static layer_gui_layer_scripts = {}
	static layer_gui_layer = {}
	static layer_gui_layer_surfaces = {}
	static layer_gui_layer_sequences = {}
	static layer_gui_layer_view = {};
	static layer_gui_global_surface = surface_create(display_get_gui_width(), display_get_gui_height())
	static layer_gui_get_global_surface = function() {
		if !surface_exists(layer_gui_global_surface)
			layer_gui_global_surface = surface_create(display_get_gui_width(), display_get_gui_height())
		return layer_gui_global_surface
	}
}
SqueeUI();


function layer_gui_ini_layer_depth(value) {
	static depth_static = value;
}

function layer_gui_get_new_layer_depth() {
	return static_get(layer_gui_ini_layer_depth).depth_static;
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


layer_gui_ini_layer_depth(-100000)


/**
 * Function Description
 * @param {id.Layer} _dummy Description
 */
function InnerLayerHolder(_dummy) constructor {
	layer_id = _dummy;	
}

/// @desc Function Description
/// @param {string} layer_id Description
/// @param {real} x Description
/// @param {real} y Description
/// @param {asset.GMSequence} sequence Description
/// @returns {id.SequenceElement} Description
/// @self {Object1}

function layer_gui_sequence_create(layer_id, x, y, sequence) {
	static context = static_get(SqueeUI);
	var active_sequences = context.layer_gui_layer_scripts
	var surfaces = context.layer_gui_layer_surfaces;
	var sequences = context.layer_gui_layer_sequences;
	
	function layer_func() {
		//maybe try working directly with the view matrix eventually
		if view_enabled {
			//this function gets called for every view, so we must always ensure that we aren't
			//adjusting unbound layers, or layers that are relative to a different view.
			static context = static_get(SqueeUI);
			var layer_id = ""
			var current = context.layer_gui_layer_view[$ layer_id];
			if view_current == current {
				var xoff = view_get_xport(current) //view_xport[current]
				var yoff = view_get_yport(current) //view_yport[current]
				var sequences = context.layer_gui_layer_sequences[$ layer_id];
				
				
				/**
				 * Function Description
				 */
				function __func_stub() constructor {
					layer_id = undefined;
					xoff = undefined;
					yoff = undefined;
				}
				
				
				
				/**
				 * Function Description
				 * @param {any*} elem Description
				 */
				static func = function(elem) {
					if layer_sequence_exists(layer_id, elem.seq) {
						layer_sequence_x(elem.seq, elem.x + xoff)
						layer_sequence_y(elem.seq, elem.y + yoff)
					}
				}
				array_foreach(sequences, method({layer_id, xoff, yoff},func))
			}
		}
		
		if event_type == ev_draw {
			var surf = SqueeUI.layer_gui_get_global_surface()
			if event_number == ev_draw_normal {
				surface_set_target(surf)
			} else if event_number == ev_gui {
				draw_surface(surf, 0,0)
			} else if event_number == ev_draw_begin {
				if surf == SqueeUI.layer_gui_get_global_surface() {
					surface_set_target(surf)
					draw_clear_alpha(c_black, 0)
					surface_reset_target()
				} 
			}
		}
	}
	
	//we use this to better manage resetting the target
	static layer_end_draw = function() {
		if event_type == ev_draw {
			if event_number == ev_draw_normal
				surface_reset_target()
		}
	}
	
	
	layer_gui_get_or_create_layer(layer_id)
	//make the sequence and track the absolute x and y in a struct
	var seq = layer_sequence_create(layer_id, x, y, sequence)
	var s = {
		seq: seq,
		x: x,
		y: y
	}
	
	//create an entry for the layer
	if !active_sequences[$ layer_id] {

		var gui_height = display_get_gui_height();
		var gui_width = display_get_gui_width();
		surfaces[$ layer_id] = SqueeUI.layer_gui_global_surface
		var struct = {layer_id}
		sequences[$ layer_id] = []
		var _method = method(struct, layer_func)
		active_sequences[$ layer_id] = _method
		layer_script_begin(layer_id, layer_func)
		layer_script_end(layer_id, method(struct,layer_end_draw))
	}
	
	array_push(sequences[$ layer_id], s)
	return seq
}

