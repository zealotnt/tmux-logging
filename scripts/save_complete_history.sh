#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

append_suffix_to_file() {
	local file="$1";
	local suffix="$2";
	if [ -z "${suffix}" ]; then
		echo "${file}";
		return
	fi

	# normalize suffix and keep safe for filenames
	suffix="$(echo "${suffix}" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g' | sed -E 's/[^a-zA-Z0-9._-]+/_/g')"

	local dir="${file%/*}"
	local base="${file##*/}"
	local name="${base%.*}"
	local ext="${base##*.}"

	if [ "${name}" = "${base}" ]; then
		echo "${file}${suffix}"
	else
		echo "${dir}/${name}-${suffix}.${ext}"
	fi
}

main() {
	local suffix=""
	while [ "$#" -gt 0 ]; do
		case "$1" in
			--suffix)
				suffix="$2"; shift 2;;
			--suffix=*)
				suffix="${1#*=}"; shift;;
			*)
				shift;;
		esac
	done

	if supported_tmux_version_ok; then
		local file=$(expand_tmux_format_path "${save_complete_history_full_filename}")
		file="$(append_suffix_to_file "${file}" "${suffix}")"
		local history_limit="$(tmux display-message -p -F "#{history_limit}")"
		tmux capture-pane -J -S "-${history_limit}" -p > "${file}"
		remove_empty_lines_from_end_of_file "${file}"
		display_message "History saved to ${file}"
	fi
}
main
