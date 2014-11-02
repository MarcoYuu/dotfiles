# Default Theme

if patched_font_in_use; then
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="⮂"
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN="⮃"
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀"
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="⮁"
else
	TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="⮂"
	TMUX_POWERLINE_SEPARATOR_LEFT_THIN="⮃"
	TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="⮀"
	TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="⮁"
fi

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'235'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'255'}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}


# Format: segment_name background_color foreground_color [non_default_separator]

if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		#"tmux_session_info 148 234" \
		"hostname 33 255" \
		"pwd 96 255" \
		#"ifstat 96 255" \
		"vcs_branch 29 253" \
		"vcs_compare 60 255" \
		"vcs_staged 64 255" \
		"vcs_modified 67 255" \
		"vcs_others 245 0" \
	)
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		#"cpu 240 136" \
		#"load 237 167" \
		#"tmux_mem_cpu_load 255 0" \
		#"battery 137 127" \
		"tmux_mem_cpu_load 245 0" \
		#"lan_ip 24 255" \
		#"wan_ip 24 255 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
		"date_day 95 255" \
		"date 95 255 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
		"time 95 255 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
	)
fi
