# proton-mail (fili-bar plugin)

New Proton mails in the Filigrane bar. `goimapnotify` listens to the local Proton Bridge (IMAP IDLE) and runs `bin/mail-notify`, which notifies with the sender and subject and raises the alert read by the bar.

```sh
fili-bar install https://github.com/filigrane-os/fili-bar-proton-mail
secret-tool store --label="Proton bridge user" service proton-bridge-user
secret-tool store --label="Proton bridge pass" service proton-bridge-pass
```

Run `protonmail-bridge --noninteractive`, point `goimapnotify` at the bridge with `onNewMail` set to `bin/mail-notify` (an example is in the Filigrane distribution).

## Personal data

The bridge credentials live in the keyring. Host and port are optional: copy `config.example.toml` to `~/.config/filigrane/bar/proton-mail.toml` (never committed).
