import QtQuick
import QtQml

import Quickshell.Hyprland

import "../.."

Item {
    id: root

    signal clicked

    required property HyprlandWorkspace workspace
    property bool hovered: hover.hovered
    property bool selected: workspace.active

    implicitHeight: label.implicitHeight + 10
    
    width: implicitHeight
    height: implicitHeight

    Column {
        anchors.fill: parent
        spacing: 0
    
        Item {
            width: root.width
            height: root.height - indicator.height
    
            Rectangle {
                anchors.fill: parent
    
                color: root.selected
                    ? Theme.workspaceActive
                    : root.hovered 
                        ? Theme.primaryHover
                        : "transparent"

                opacity: root.selected
                    ? 0.65
                    : root.hovered 
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
                anchors.topMargin: 3
    
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
    
                text: root.workspace.name
    
                font.pixelSize: 14
                font.family: ibmPlexMono.name

                color: {
                    if (root.workspace.toplevels.values.length > 0) {
                        root.selected
                            ? Theme.textBright
                            : Theme.text
                    } else {
                        Theme.textMuted
                    }
                }
            }
        }
    
        Rectangle {
            id: indicator
    
            color: Theme.primaryActive
            opacity: root.selected
                ? 1
                : root.hovered 
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
            if (Hyprland.usingLua) {
                console.log("no lua support")
            } else {
                Hyprland.dispatch(
                    `workspace ${root.workspace.name}`
                )
            }
        }
    }
}