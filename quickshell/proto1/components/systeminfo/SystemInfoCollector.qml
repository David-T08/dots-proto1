import QtQuick
import Quickshell.Io
import Quickshell

Item {
    id: root

    property string cpu: "0"
    property string ram: "0G"
    property string temp: "N/A"
    property string netDown: "0B"
    property string netUp: "0B"

    Process {
        id: statsProc

        command: [
            "bash",
            "-c",
            Quickshell.shellDir + "/other/scripts/query_sys_info.sh"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split("|")

                for (const part of parts) {
                    const [key, value] = part.split(":")

                    if (key === "CPU") root.cpu = value
                    else if (key === "RAM") root.ram = value
                    else if (key === "TMP") root.temp = value
                    else if (key === "DOWN") root.netDown = value
                    else if (key === "UP") root.netUp = value
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: statsProc.running = true
    }

    Component.onCompleted: statsProc.running = true
}