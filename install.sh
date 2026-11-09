#!/bin/sh
# First-run setup, run by `fili-bar install` / `fili-bar setup` / `fili-bar sync`. Idempotent; asks questions only on a terminal.
# Secrets never go in this folder: they go to the keyring or to a file under ~/.config.
set -u
here="$(cd "$(dirname "$0")" && pwd)"
opts="${FILI_BAR_OPTIONS:-$HOME/.config/filigrane/bar/proton-mail.toml}"
tty=0; [ -t 0 ] && tty=1
# Options file: copy the example once, never overwrite
if [ ! -e "$opts" ] && [ -f "$here/config.example.toml" ]; then
    mkdir -p "$(dirname "$opts")" && cp "$here/config.example.toml" "$opts" && echo "options: $opts (edit it to change the defaults)"
fi
# Bridge credentials: keyring only
command -v secret-tool >/dev/null 2>&1 || { echo "secret-tool (libsecret) is required" >&2; exit 1; }
if [ -z "$(secret-tool lookup service proton-bridge-user 2>/dev/null)" ]; then
    if [ "$tty" = 1 ]; then
        printf 'Proton Bridge user (the bridge username, not your Proton password): '; read -r u
        printf 'Proton Bridge password: '; stty -echo 2>/dev/null; read -r p; stty echo 2>/dev/null; echo
        [ -n "$u" ] && [ -n "$p" ] || { echo "empty value, nothing stored" >&2; exit 1; }
        printf '%s' "$u" | secret-tool store --label="Proton bridge user" service proton-bridge-user
        printf '%s' "$p" | secret-tool store --label="Proton bridge pass" service proton-bridge-pass
        echo "credentials stored in the keyring"
    else
        echo "store the bridge credentials: secret-tool store --label=\"Proton bridge user\" service proton-bridge-user (and ...-pass)"
    fi
fi
command -v goimapnotify >/dev/null 2>&1 || echo "goimapnotify is not installed (sudo xbps-install goimapnotify)"
command -v protonmail-bridge >/dev/null 2>&1 || echo "protonmail-bridge is not installed (sudo xbps-install protonmail-bridge)"
echo "goimapnotify: set onNewMail to $here/bin/mail-notify"
