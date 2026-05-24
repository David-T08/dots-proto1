import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import "../.."
import ".."

Item {
    id: root
    required property SystemTrayItem item
    required property string title

    function open() {
        menuPopup.visible = true
    }

    function toggle() {
        menuPopup.visible = !menuPopup.visible
    }

    QsMenuOpener {
        id: menuOpener
        menu: root.item.menu
    }

    PopupWindow {
        id: menuPopup
        grabFocus: true
        
        anchor.window: topbar
        anchor.item: root
        anchor.rect.x: root.width / 2 - width / 2
        anchor.rect.y: topbar.height

        property real menuWidth: 0
        
        implicitWidth: Math.max(menuWidth + 12, 140)
        implicitHeight: menuColumn.implicitHeight + 12
        visible: false

        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Theme.panelElevated
            border.color: Theme.bracketDim
            border.width: 1

            // Hazard {
            //     anchors.fill: parent
                
            // }

            Column {
                id: menuColumn
                anchors.fill: parent
                anchors.margins: 6
                spacing: 2

                

                Repeater {
                    model: menuOpener.children

                    delegate: Item {
                        required property QsMenuEntry modelData
                        
                        width: parent.width
                        height: modelData.isSeparator ? 8 : 26

                        Component.onCompleted: {
                            menuPopup.menuWidth = Math.max(
                                menuPopup.menuWidth,
                                textItem.implicitWidth + 16
                            )
                        }

                        // Rectangle {
                        //     visible: modelData.isSeparator
                        //     anchors.centerIn: parent
                        //     width: parent.width
                        //     height: 1
                        //     color: Theme.textMuted
                        //     opacity: 0.4
                        // }

                        Hazard {
                            visible: modelData.isSeparator
                            anchors.centerIn: parent
                            
                            width: parent.width
                            height: 4

                            opacity: 0.4
                            speed: 5000
                            color: Theme.primary
                        }

                        Text {
                            id: textItem
                            
                            visible: !modelData.isSeparator
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8

                            text: modelData.text
                            color: modelData.enabled ? Theme.text : Theme.textMuted

                            font.family: ibmPlexMono.name
                            font.pixelSize: 12
                        }

                        HoverHandler {
                            id: hover
                        }

                        Rectangle {
                            visible: !modelData.isSeparator
                            anchors.fill: parent
                            color: Theme.primaryHover
                            opacity: hover.hovered ? 0.25 : 0
                        }

                        TapHandler {
                            enabled: !modelData.isSeparator && modelData.enabled
                            onTapped: {
                                modelData.triggered()
                                menuPopup.visible = false
                            }
                        }
                    }
                }
            }
        }
    }
}