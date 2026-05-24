import QtQuick

import Quickshell.Services.SystemTray

import ".."
import "../.."

Brackets {
    id: root

    height: parent.height
    
    contentWidth: Math.ceil(content.implicitWidth)
    contentHeight: Math.ceil(parent.height)

    horizontalPadding: 12
    
    Row {
        id: content
        spacing: 4

        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: SystemTray.items
    
            delegate: SystemTrayButton {
                required property SystemTrayItem modelData
                item: modelData
            }
        }
    }

    Component.onCompleted: openAnim.start()
    
    SequentialAnimation {
        id: openAnim

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "revealHeight"
                to: 1.0
                duration: 400
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: root
                property: "opacity"
                to: 1
                duration: 400
            }
        }

        NumberAnimation {
            target: root
            property: "revealWidth"
            to: 1.0
            duration: 850
            easing.type: Easing.OutCubic
        }
    }
}