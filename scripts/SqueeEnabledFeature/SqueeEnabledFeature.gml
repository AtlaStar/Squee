// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function SqueeEnabledFeature(){
	return _GMFUNCTION_
}

//enabled by default
function enable_seq_event_step_replacement(predicate = function(args) {return true}, args = []) {
	if predicate(args) {
		asset_add_tags("event_step_replacement", SqueeEnabledFeature(), asset_script)
	}
}
function disable_seq_event_step_replacement(predicate = function(args) {return true}, args = []) {
	if predicate(args) {
		asset_remove_tags("event_step_replacement", SqueeEnabledFeature(), asset_script)
	}
}

//disabled by default
function enable_deep_sequence_clone(predicate = function(args){return true}, args = []) {
	if predicate(args) {
		asset_add_tags("TO_DO", SqueeEnabledFeature(), asset_script)
	}
}
function disable_deep_sequence_clone(predicate = function(args){return true}, args = []) {
	if predicate(args) {
		asset_remove_tags("TO_DO", SqueeEnabledFeature(), asset_script)
	}
}

//disabled by default
function enable_require_sequence_builders(predicate = function(args) {return true}, args = []) {
	if predicate(args) {
		asset_add_tags("TO_DO", SqueeEnabledFeature(), asset_script)
	}
}
function disable_require_sequence_builders(predicate = function(args) {return true}, args = []) {
	if predicate(args) {
		asset_remove_tags("TO_DO", SqueeEnabledFeature(), asset_script)
	}
}

function enable_auto_replace_anchors(predicate = function(args){return true},args = []) {
	if predicate(args) {
		asset_add_tags("squee_auto_replace_anchors", SqueeEnabledFeature(), asset_script)	
	}
}