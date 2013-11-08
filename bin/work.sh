#!/bin/bash
#
# work.sh
# Leon Miller-Out - leon@singlebrook.com
#
# Fires up everything I need to work on a Rails app.
#
# SETUP
# - put Pivotal Tracker project ID in .pivotal_tracker_id
#
# DEPENDENCIES
# - OS X
# - SizeUp (optional - you have to run "workon set move_windows=yes")
# - Sublime Text 2 (optional - defaults to RubyMine, you can run "workon set editor=st")
# - bundle command in your path
# - git command in your path
# - term script (included in distribution)
#
# TODO
# * Project-specific TCP ports
# * Use user's default browser instead of Chrome. It's hard to figure out what the
#   default browser is on OS X. We have the workaround of setting BROWSER in the
#   env, but it doesn't work properly with Firefox.
#  /Applications/Firefox.app/Contents/MacOS/firefox-bin <url> will open in Firefox, so that 
#  may be a workaround, except how to position the window? 

set -e

# Detect paths and set up variables for various commands
CMD_BIN=`echo $0`
echo $CMD_BIN
CMD_PATH=`dirname $CMD_BIN`
TERM=$CMD_PATH/term

if [ "$WORKON_MOVE_WINDOWS" == "yes" ]; then
	source $CMD_PATH/window_funcs.inc
fi

if [ "$WORKON_BROWSER" == "" ]; then
	WORKON_BROWSER="Google Chrome"
fi

BROWSER_CMD='open'
# if [[ "$WORKON_BROWSER" == 'Firefox' ]]; then
# 	BROWSER_CMD='/Applications/Firefox.app/Contents/MacOS/firefox-bin'
# fi

if [ -f Gemfile ]; then
  echo "Checking gem dependencies"
  bundle check
  if [ $? -ne 0 ]; then
    bundle
  fi
fi

# Find an available port
PORT=3000
while [[ PORT -lt 3010 ]]; do
  PORT_IN_USE=`netstat -an | grep LISTEN | grep $PORT | wc -l`
  if [[ PORT_IN_USE -eq 0 ]]; then
    # Port is available
    break
  fi
  PORT=`expr $PORT + 1`
done
if [[ $PORT -eq 3010 ]]; then
  echo "No ports between 3000 and 3010 available"
  exit 1
fi
if [ -f Procfile ]; then
  echo "Starting Foreman"
  RAILS_CMD="env PORT=$PORT foreman start"
elif [ -f script/server ]; then
  echo "Starting Rails 2"
  RAILS_CMD="bundle exec script/server -p $PORT"
else
  echo "Starting Rails"
  RAILS_CMD="bundle exec rails server -p $PORT"
fi
$TERM -r -t $RAILS_CMD > /dev/null

# GIT WINDOW POSITION
if [[ "$WORKON_MOVE_WINDOWS" == "yes" ]]; then
	move_front_window "Terminal" "Second Monitor"
	move_front_window "Terminal" "Lower Right"
fi

if [ -f Guardfile ]; then
  	echo "Starting Guard"
	$TERM -r -t bundle exec guard -c > /dev/null
	if [[ "$WORKON_MOVE_WINDOWS" == "yes" ]]; then
	  move_front_window "Terminal" "Second Monitor"
	  move_front_window "Terminal" "Upper Left"
	fi
fi

echo "Opening project in RubyMine"
$WORKON_EDITOR .
sleep 1
if [[ "$WORKON_MOVE_WINDOWS" == "yes" ]]; then
	move_front_window "Sublime Text 2" "Second Monitor"
	move_front_window "Sublime Text 2" "Upper Right"
fi

# Make sure we've got a browser window on the current desktop
osascript -e "tell application \"$WORKON_BROWSER\" to make new window" > /dev/null
if [ "$WORKON_MOVE_WINDOWS" == "yes" ]; then
	move_front_window_to_primary_monitor "$BROWSER"
	move_front_window "$BROWSER" "Full Screen"
fi

# Open AC page for project
if [[ "$WORKON_AC_URL" != "" && "$WORKON_AC" !="" ]]; then
	echo "Opening ActiveCollab project"
	$BROWSER_CMD https://$WORKON_AC_URL/projects/$WORKON_AC/tasks
fi

if [[ "$WORKON_TRACKER_ID" != "" ]]; then
  echo "Opening Tracker project"
  $BROWSER_CMD https://www.pivotaltracker.com/projects/$WORKON_TRACKER_ID
fi

if [[ "$GITHUB_REPO" != "" ]]; then
  echo "Opening Github repo"
  $BROWSER_CMD https://github.com/$GITHUB_REPO
fi

osascript -e "tell application \"Terminal\" to activate"

echo "Waiting for local site to come up..."

# Open the local site once it's up and running
SITE_AVAILABLE=0
while [[ SITE_AVAILABLE -eq 0 ]]; do
  SITE_AVAILABLE=`netstat -an | grep LISTEN | grep $PORT | wc -l`
  sleep 1
done
echo "Opening local site"
PROJECT_FOLDER=`pwd | sed 's:.*/::' | sed 's/_//g'`
$BROWSER_CMD http://$WORKON_DOMAIN:$PORT

# Clean up that empty browser tab
osascript -e "tell application \"$WORKON_BROWSER\" to close first tab of front window"
