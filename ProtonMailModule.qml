// New Proton mails (hidden when there are none), click = open Proton Mail and clear
import QtQuick
import qs
import qs.bar.modules.alert

AlertModule {
    kind: "mail"
    title: "Proton Mail"
    url: "https://mail.proton.me"
    glyph: ""
    accent: FiliTheme.voile
}
