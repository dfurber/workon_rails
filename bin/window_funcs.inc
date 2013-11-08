focus_terminal_window() {
  local search_string=$1

  local focus_script="
    tell application \"Terminal\"
      repeat with w in windows
        if custom title of w contains \"$search_string\" then
          set frontmost of w to true
        end if
      end repeat
    end tell
  "
  osascript -e "$focus_script"
}

move_front_window() {
  local app=$1
  local location=$2

  if [ "$location" == "Second Monitor" ]; then
    # Make sure window is on primary monitor to begin with
    move_front_window_to_primary_monitor "$app"
    location="Prev Monitor"
  fi

  osascript -e "
    tell application \"$app\" to activate
    tell application \"System Events\"
      tell application \"SizeUp\" to do action $location
    end tell
  "
}

move_front_window_to_primary_monitor() {
  local app=$1
  osascript -e "tell application \"$app\" to set bounds of front window to {0,0,500,500}" &> /dev/null || true
}

zoom() {
  local app=$1
  local zoom_applescript="tell application \"$app\" to activate
  tell application \"System Events\"
    tell process \"$app\"
      tell menu bar 1
        tell menu \"Window\"
          click menu item \"Zoom\"
        end tell
      end tell
    end tell
  end tell"
  osascript -e "$zoom_applescript"
}