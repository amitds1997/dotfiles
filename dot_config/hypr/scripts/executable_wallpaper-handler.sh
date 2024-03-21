#!/usr/bin/env bash

ACTION=$1

WALLPAPER_DIR="$XDG_DATA_HOME/wallpapers"
WALLPAPER_CACHE_FILE="$XDG_CACHE_HOME/current_wallpaper"

if [ ! -f "$WALLPAPER_CACHE_FILE" ]; then
	touch "$WALLPAPER_CACHE_FILE"
fi

LAST_APPLIED_WALLPAPER=$(cat "$WALLPAPER_CACHE_FILE")
CURRENT_WALLPAPER=""

if [ "$LAST_APPLIED_WALLPAPER" == "" ] && [ "$ACTION" == "init" ]; then
	ACTION="random"
else
	CURRENT_WALLPAPER=$LAST_APPLIED_WALLPAPER
fi

case $ACTION in

"init") # Initial load
	swww init
	;;

"rofi")
	SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -type f -exec basename {} \; | sort -R | while read -r rfile; do
		echo -en "$rfile\x00icon\x1f${WALLPAPER_DIR}/${rfile}\n"
	done | rofi -dmenu -replace)
	if [ ! "$SELECTED_WALLPAPER" ]; then
		echo "No wallpaper selected"
		exit
	fi
	CURRENT_WALLPAPER=$WALLPAPER_DIR/$SELECTED_WALLPAPER
	;;

"random")
	CURRENT_WALLPAPER="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
	;;
esac

if [ "$CURRENT_WALLPAPER" != "$LAST_APPLIED_WALLPAPER" ]; then
	swww img "${CURRENT_WALLPAPER}" --transition-fps 30 --transition-type center --transition-duration 1
	wal -i "${CURRENT_WALLPAPER}" -n -s -t -q

	# If everything succeeded, write this as the last applied wallpaper
	echo "$CURRENT_WALLPAPER" >"$WALLPAPER_CACHE_FILE"
elif [ "$ACTION" != "init" ]; then
	echo "No change in wallpaper"
fi
