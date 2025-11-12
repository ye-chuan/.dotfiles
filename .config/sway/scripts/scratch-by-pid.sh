#!/bin/bash
# This script takes a program / shell command, executes it, then move it to the scratchpad using the PID.
# I wrote this because I wanted a more universal method for spawning floating windows in sway that doesn't
# rely on some app_id or class name "hacks". Hopefully sway implements a function to spawn just a specific
# instance of exec in the scratchpad, then this "hacky" script can be replaced.
# LIMITATION: For many programs (e.g. firefox), the PID we get is just an initial wrapper around the actual
# process, hence this method will not work.

TIMEOUT=5   # Seconds before giving up on waiting for the window to appear

if [ -z "$@" ]; then
    echo No Command Specified >&2
    exit
fi

# Manually piping because `swaymsg --monitor ... | jq ...` creates a pipeline that only
# terminates after the swaymsg attempts to write to the pipe again even after jq has terminated
tmpdir="$(mktemp -d)"
pipe="$tmpdir/pipe"
mkfifo "$pipe"
echo Created Pipe At: "$pipe"

cleanup() {
    rm "$pipe"
    rmdir "$tmpdir"
    echo "Pipe at $pipe destroyed"
}
trap 'cleanup' EXIT

# Starts a program in shell and move it to scratchpad via its PID
echo Running: "$@"
"$@" &
pid=$!
echo PID: "$pid"

wait_and_move() {
    # Waits for container with the pid to appear
    echo Imported Variables: pipe="$pipe", pid="$pid"
    # HACK: On the failure case, swaymsg --monitor could technically be a zombie
    # But as long as any new window event occur, it should terminate on BROKEN PIPE
    swaymsg --monitor --type subscribe '["window"]' >"$pipe" &
    jq "select(.change == \"new\" and .container.pid == "$pid") | halt" <"$pipe" && \
        swaymsg [pid="$pid"] move window to scratchpad, focus
}

export -f wait_and_move
export pipe pid
# NOTE: Will not be able to repond to SIGTERM to the script beacuse `timeout`, its command and descendents are in a seperate Process Group
timeout 5 bash -c 'wait_and_move'

