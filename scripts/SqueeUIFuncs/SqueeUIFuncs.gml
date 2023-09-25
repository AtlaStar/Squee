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


//TO-DO: after adding view binding, make it so that marked GUI layers are scaled to draw atop the bound view
//Also, test if resizing to clear and to avoid the odd bug with the display_get_gui_* methods is performant or not.
function squee_ui_layer_func() {
	var surf = squee_cache.surfaces.get(layer)
		
	if surf == undefined || !surface_exists(surf) {
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

function squee_ui_layer_end_func() {
	if event_type == ev_draw {
		if event_number == ev_draw_normal {
			surface_reset_target()
		}
	}
}


/// @desc Creates a SqueeUI enabled sequence. Uses a managed canvas to ensure proper scaling.
/// @param {string} layer_id The layer id to use (will create a layer if it doesn't already exist)
/// @param {real} x the x position to draw on the GUI canvas
/// @param {real} y the y position to draw on the GUI canvas
/// @param {asset.GMSequence | struct.Sequence} sequence The sequence asset OR object to use to create the sequence instance
/// @returns {id.SequenceElement} A layer element id representing the sequence instance
/// @context undefined
function layer_gui_sequence_create(layer_id, x, y, sequence) {

	layer_gui_get_or_create_layer(layer_id)
	layer_script_begin(layer_id, squee_ui_layer_func)
	layer_script_end(layer_id, squee_ui_layer_end_func)

	return layer_sequence_create(layer_id, x, y, sequence)
}


function SqueeUICanvasElement(layer_id, x, y, element, x_relative = true, y_relative = true) constructor {

	seq_element = layer_gui_sequence_create(layer_id, x, y, element)

	self.x_orig = x;
	self.y_orig = y;
	self.x_rel = x_relative
	self.y_rel = y_relative
	gui_xscale = display_get_gui_width();
	gui_yscale = display_get_gui_height();

	var reposition = function() {
		var _width = display_get_gui_width();
		var _height = display_get_gui_height();
		if x_rel && gui_xscale != _width {
			var new_x = x_orig * (_width/gui_xscale)
			gui_xscale = _width;
			layer_sequence_x(seq_element, floor(new_x))
		} else if gui_xscale != _width {
			//TO-DO?
		}
		if y_rel && gui_yscale != _height {
			var new_y = y_orig * (_height/gui_yscale)
			gui_yscale = _height
			layer_sequence_y(seq_element, floor(new_y))
		} else if gui_yscale != _height {
			//TO-DO?
		}
	}


	static sequence_instance_step_event = function(_event = undefined) {
		var seq_inst = layer_sequence_get_instance(seq_element)
		if _event = undefined {
			return seq_inst.original_step_event
		}
		seq_inst.original_step_event = _event
		return seq_inst.original_step_event;
	}
	timesource = time_source_create(time_source_game, 1, time_source_units_frames, reposition,[],-1)
	time_source_start(timesource)
}