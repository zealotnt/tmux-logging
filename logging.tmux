#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/variables.sh"
source "$CURRENT_DIR/scripts/shared.sh"


main() {
	tmux bind-key "$logging_key" run-shell "$CURRENT_DIR/scripts/toggle_logging.sh"
	tmux bind-key "$pane_screen_capture_key" run-shell "$CURRENT_DIR/scripts/screen_capture.sh"
	# Save complete history with optional suffix prompt
	tmux bind-key "$save_complete_history_key" command-prompt -p "History suffix:" "run-shell '$CURRENT_DIR/scripts/save_complete_history.sh --suffix %1'"
	# Save complete history with ANSI codes with optional suffix prompt
	tmux bind-key "$save_complete_history_with_ansi_key" command-prompt -p "History suffix:" "run-shell '$CURRENT_DIR/scripts/save_complete_history_with_ansi_code.sh --suffix %1'"
	tmux bind-key "$clear_history_key" run-shell "$CURRENT_DIR/scripts/clear_history.sh"
}

main
