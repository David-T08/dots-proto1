import QtQuick
import Quickshell

PopupWindow {
    id: root
    visible: false

    implicitWidth: 600
    implicitHeight: 400

    anchor.rect.x: screen.width / 2 - width / 2
    anchor.rect.y: screen.height / 2 - height / 2

    Rectangle {
        anchors.fill: parent

        radius: 12
        color: "#101820EE"

        border.width: 1
        border.color: "#233243"
    }
}