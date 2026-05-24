import QtQuick

import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

import ".."
import "../.."

Item {
    id: root

    signal clicked

    required property SystemTrayItem item
    property bool hovered: hover.hovered

    implicitHeight: icon.implicitHeight + 10

    width: implicitHeight
    height: implicitHeight

    visible: item.status !== Status.Passive

    Column {
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

            IconImage {
                id: icon

                anchors.fill: parent
                anchors.margins: 4
                implicitSize: 24

                asynchronous: true
                source: root.item.icon
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

    SystemTrayMenu {
        id: trayMenu
        item: root.item
        title: root.item.title.length > 0 ? root.item.title : root.item.tooltipTitle
    }

    HoverHandler {
        id: hover
    }

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: trayMenu.toggle()
    }
}