import QtQuick
import QtQml

import "../.."

Item {
    id: root

    signal clicked

    property bool hovered: hover.hovered
    property real size: 24
    
    property color hoveredColor: Theme.text
    property color color: Theme.text
    
    required property string icon

    // implicitHeight: label.implicitHeight
    
    implicitWidth: root.size + 5
    implicitHeight: root.size + 5

    Column {
        anchors.topMargin: 2
        anchors.fill: parent
        spacing: 0
    
        Item {
            width: root.width
            height: root.height - indicator.height
    
            Rectangle {
                anchors.fill: parent
    
                color: root.hovered 
                    ? Theme.primaryHover
                    : "transparent"

                opacity: root.hovered 
                    ? 0.5
                    : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }
    
            Text {
                id: label
                anchors.centerIn: parent
    
                text: root.icon
    
                font.pixelSize: root.size - 6
                font.family: "Hack Nerd Font"

                color: root.hovered 
                    ? root.hoveredColor
                    : root.color
                    

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    
        Rectangle {
            id: indicator
    
            color: Theme.primaryActive
            opacity: root.hovered 
                ? 0.75
                : 0

            width: parent.width
            height: 2
    
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    HoverHandler {
        id: hover
    }

    TapHandler {
        onTapped: {

        }
    }
}