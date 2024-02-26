#!/bin/bash

COUNT=$(dunstctl count waiting)

if dunstctl is-paused | grep -q "false"; then
	printf '{"text": "", "class": "enabled", "tooltip": "Notifications on"}\n'
elif [ "$COUNT" != 0 ]; then
	printf '{"text": "", "class": "snoozed", "tooltip": "%s snoozed notification(s)"}\n' "$COUNT"
else
	printf '{"text": "", "class": "disabled", "tooltip": "Notifications off"}\n'
fi
