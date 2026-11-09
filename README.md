# proton-mail (fili-bar plugin)

New Proton mails in the Filigrane bar. `goimapnotify` listens to the local Proton Bridge (IMAP IDLE) and runs `bin/mail-notify`, which notifies with the sender and subject and raises the alert read by the bar.

```sh
fili-bar install https://github.com/filigrane-os/fili-bar-proton-mail
secret-tool store --label="Proton bridge user" service proton-bridge-user
secret-tool store --label="Proton bridge pass" service proton-bridge-pass
```

Run `protonmail-bridge --noninteractive`, point `goimapnotify` at the bridge with `onNewMail` set to `bin/mail-notify` (an example is in the Filigrane distribution).

`fili-bar install` also runs `install.sh`: it creates your options file from `config.example.toml`, asks for what is missing (credentials go to the keyring or to a file under `~/.config`, never to this folder) and prints what is left to do. Run it again with `fili-bar setup proton-mail`; it is safe to repeat.

## Personal data

The bridge credentials live in the keyring. Host and port are optional: copy `config.example.toml` to `~/.config/filigrane/bar/proton-mail.toml` (never committed).
