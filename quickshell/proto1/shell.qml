//@ pragma UseQApplication

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

import "./components/systeminfo"
import "./panels"

ShellRoot {
    id: sroot

    property alias clock: globalClock
    property alias sysinfo: sysinfoCollector

    property var mediaPlayer: (
        Mpris.players.values.find(p => p.isPlaying)
        ?? Mpris.players.values[0]
    )

    SystemClock {
        id: globalClock
        precision: SystemClock.Seconds
    }

    SystemInfoCollector {
        id: sysinfoCollector
    }

    Connections {
        target: Quickshell
        function onReloadCompleted() { Quickshell.inhibitReloadPopup() }
        function onReloadFailed(errorString) { Quickshell.inhibitReloadPopup() }
    }

    FontLoader {
        id: hackedFont
        source: "assets/fonts/HACKED.ttf"
    }

    FontLoader {
        id: ibmPlexMono
        source: "assets/fonts/IBMPlexMono-Regular.ttf"
    }

    FontLoader {
        id: ibmPlexMonoBold
        source: "assets/fonts/IBMPlexMono-Bold.ttf"
    }

    Main {}
    Floating {}
}