import QtQuick

import ".."
import "../.."

Brackets {
    id: systemcontroltray

    height: parent.height
    
    contentWidth: Math.ceil(content.implicitWidth)
    contentHeight: Math.ceil(parent.height)

    horizontalPadding: 12
    
    Row {
        id: content
        spacing: 8

        anchors.verticalCenter: parent.verticalCenter

        SystemControlButton {
            icon: "󰒓"
            hoveredColor: Theme.textMuted
        }
        
        SystemControlButton {
            icon: "󰂯"
            hoveredColor: Theme.primaryHover
        }

        SystemControlButton {
            icon: "󰖩" 
            hoveredColor: Theme.primaryHover
        }

        SystemControlButton {
            icon: "󰕾"
            hoveredColor: Qt.lighter(Theme.accentHover, 1.25)
        }

        SystemControlButton {
            icon: "⏻"
            hoveredColor: Qt.lighter(Theme.dangerHover, 1.15)
        }
    }

    Component.onCompleted: openAnim.start()
    
    SequentialAnimation {
        id: openAnim

        ParallelAnimation {
            NumberAnimation {
                target: systemcontroltray
                property: "revealHeight"
                to: 1.0
                duration: 400
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: systemcontroltray
                property: "opacity"
                to: 1
                duration: 400
            }
        }

        NumberAnimation {
            target: systemcontroltray
            property: "revealWidth"
            to: 1.0
            duration: 850
            easing.type: Easing.OutCubic
        }
    }
}