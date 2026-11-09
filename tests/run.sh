#!/bin/sh
# Tests of the proton-mail plugin: no network and no real account (the external commands are stubs). Usage: tests/run.sh
PLUGIN=proton-mail
. "$(dirname "$0")/common.sh"

stub secret-tool 'echo stub-value'
common_checks
# options: host and port, with defaults
printf 'host = "10.1.2.3"   # comment\nport = 2143\n' > "$T/options.toml"
check "opt reads host and port from the options file" '[ "$(in_env sh -c ". $ROOT/bin/opt.sh; opt host x; opt port y")" = "10.1.2.32143" ]'
rm -f "$T/options.toml"
check "opt falls back to the defaults" '[ "$(in_env sh -c ". $ROOT/bin/opt.sh; opt host 127.0.0.1; opt port 1143")" = "127.0.0.11143" ]'
# no reachable bridge: the generic notification and alert, never a crash
printf 'port = 1\n' > "$T/options.toml"; : > "$LOG"
stub secret-tool 'echo stub-value'
in_env "$ROOT/bin/mail-notify" > /dev/null 2>&1
check "mail-notify without a reachable bridge falls back to a generic notification" 'grep -q "notify-send .*New mail" "$LOG"'
check "mail-notify raises the alert read by the bar" 'grep -q "bar-alert push mail Proton New mail" "$LOG"'
check "no credential in the scripts" '! grep -nE "PB_(USER|PASS)=\"[^\$]" "$ROOT/bin/mail-notify"'
check "manifest autostarts the bridge and the listener" 'grep -q "^autostart = .*protonmail-bridge.*goimapnotify" "$ROOT/module.toml"'

check "extras: the fallback app menu is valid JSON" 'for f in "$ROOT"/extras/config/filigrane/appmenu/*.json; do jq -e .menus "$f" > /dev/null || exit 1; done'
check "extras: no personal data" '! grep -rEiq "@[a-z0-9-]+[.][a-z]|/home/[a-z]" "$ROOT/extras"'

exit "$fail"
