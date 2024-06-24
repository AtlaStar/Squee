// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function __enable_if_intern (
	args = [],
	predicate = function(args) {
		return array_reduce(
			args, 
			function(prev, curr) {
				return prev && curr
			},
			true
		)
	}
) {
	enabled = bool(predicate(args));
}
