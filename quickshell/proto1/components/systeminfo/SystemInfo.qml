import QtQuick

import ".."
import "../.."

Brackets {
    id: systeminfo

    height: parent.height
    
    contentWidth: Math.ceil(content.implicitWidth)
    contentHeight: Math.ceil(parent.height)

    horizontalPadding: 12
    
    function tempColor() {
        const t = parseInt(sroot.sysinfo.temp)
    
        if (isNaN(t)) return Theme.textMuted
        if (t >= 85) return Theme.dangerActive
        if (t >= 70) return Theme.warning
        return Theme.text
    }
    
    Row {
        id: content
        spacing: 8

        anchors.verticalCenter: parent.verticalCenter

        Column {
            Text {
                textFormat: Text.RichText
                
                text: 
                    `<span style="color:${Theme.textMuted}">CPU:</span> ` +
                    `<span style="color:${Theme.text}">${sroot.sysinfo.cpu}%</span>`

                font.family: ibmPlexMono.name
                font.pixelSize: 13
                color: Theme.text
            }

            Text {
                textFormat: Text.RichText
                
                text: 
                    `<span style="color:${Theme.textMuted}">RAM:</span> ` +
                    `<span style="color:${Theme.text}">${sroot.sysinfo.ram}</span>`

                font.family: ibmPlexMono.name
                font.pixelSize: 13
                color: Theme.text
            }
        }

        Rectangle {
            width: 1
            height: parent.height

            color: Theme.textMuted
        }

        Column {
            Text {
                textFormat: Text.RichText
                
                text:
                    `<span style="color:${Theme.textMuted}">TMP:</span> ` +
                    `<span style="color:${systeminfo.tempColor()}">${sroot.sysinfo.temp}</span>`

                font.family: ibmPlexMono.name
                font.pixelSize: 13
                color: Theme.text
            }

            Text {
                textFormat: Text.RichText
                
                text:
                    `<span style="color:${Theme.textMuted}">NET:</span> ` +
                    `<span style="color:${Theme.successActive}">↓${sroot.sysinfo.netDown}</span> ` +
                    `<span style="color:${Theme.specialActive}">↑${sroot.sysinfo.netUp}</span>`

                font.family: ibmPlexMono.name
                font.pixelSize: 13
                color: Theme.text

                width: 125
            }
        }
    }

    Component.onCompleted: openAnim.start()
    
    SequentialAnimation {
        id: openAnim

        ParallelAnimation {
            NumberAnimation {
                target: systeminfo
                property: "revealHeight"
                to: 1.0
                duration: 400
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: systeminfo
                property: "opacity"
                to: 1
                duration: 400
            }
        }

        NumberAnimation {
            target: systeminfo
            property: "revealWidth"
            to: 1.0
            duration: 850
            easing.type: Easing.OutCubic
        }
    }
}