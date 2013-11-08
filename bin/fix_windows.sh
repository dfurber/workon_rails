#!/bin/bash

source $CMD_PATH/window_funcs.inc

# Place git window
focus_terminal_window "$APP_NAME"
move_front_window "Terminal" "Second Monitor"
move_front_window "Terminal" "Lower Right"

# Place Guard window
focus_terminal_window "Spork"
move_front_window "Terminal" "Second Monitor"
move_front_window "Terminal" "Upper Left"

# Place Sublime Text 2 window
move_front_window "Sublime Text 2" "Second Monitor"
move_front_window "Sublime Text 2" "Upper Right"