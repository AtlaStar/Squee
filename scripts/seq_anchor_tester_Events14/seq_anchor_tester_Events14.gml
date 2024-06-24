// Auto-generated stubs for each available event.

function seq_anchor_tester_event_create()
{
}

function seq_anchor_tester_event_destroy()
{

}

function seq_anchor_tester_event_clean_up()
{

}

function seq_anchor_tester_event_step()
{
	with(shield_slot.instanceID) {
		if object_index != obj_shield_in_use
			instance_change(obj_shield_in_use, true)
	}
}

function seq_anchor_tester_event_step_begin()
{

}

function seq_anchor_tester_event_step_end()
{

}

function seq_anchor_tester_event_async_system()
{

}