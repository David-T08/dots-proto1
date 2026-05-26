import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io

import "../.."
import "../../components"

PopupWindow {
    id: altTab

    signal accepted()

    property var monitor: Hyprland.monitorFor(floatingWidget.screen)
    property var workspace: monitor?.activeWorkspace

    property bool requestedVisible: false
    property bool shouldShow: false

    property string mode: "windows"
    property int selectedIndex: 0
    property bool openedThisHold: false

    property var mruWindows: []
    property var shownItems: []

    property var openedScreen: null
    property bool openedOnThisScreen: openedScreen === floatingWidget.screen

    function touchWindow(w) {
        if (!w) return
        mruWindows = [w].concat(mruWindows.filter(x => x !== w))
    }

    function sortedWindows(list) {
        const arr = list ?? []

        return arr.slice().sort((a, b) => {
            const ai = mruWindows.indexOf(a)
            const bi = mruWindows.indexOf(b)

            if (ai === -1 && bi === -1) return 0
            if (ai === -1) return 1
            if (bi === -1) return -1
            return ai - bi
        })
    }

    function refreshItems() {
        if (mode === "monitor-windows") {
            shownItems = sortedWindows(
                Hyprland.toplevels?.values?.filter(t =>
                    t.monitor === monitor
                ) ?? []
            )
        } else if (mode === "workspace-windows") {
            shownItems = sortedWindows(
                workspace.toplevels?.values ?? []
            )
        } else if (mode === "windows") {
            shownItems = sortedWindows(Hyprland.toplevels?.values ?? [])
        } else if (mode === "monitor-workspaces") {
            shownItems = Hyprland.workspaces?.values?.filter(t =>
                t.toplevels.values.length > 0 && t.monitor == monitor
            ) ?? []
        } else if (mode === "workspaces") {
            shownItems = Hyprland.workspaces?.values?.filter(t =>
                t.toplevels.values.length > 0
            ) ?? []
        } else if (mode === "screens") {
            shownItems = Quickshell.screens
        } else {
            shownItems = []
        }
    }

    Connections {
        target: ToplevelManager

        function onActiveToplevelChanged() {
            touchWindow(ToplevelManager.activeToplevel)
        }
    }

    onRequestedVisibleChanged: {
        if (requestedVisible) {
            refreshItems()
            if (monitor?.focused) {
                openedScreen = floatingWidget.screen
            }
            
            shouldShow = true

            selectedIndex = mode.includes("windows")
                ? Math.min(1, itemCount - 1)
                : 0

            openedThisHold = true
        }
    }

    function switchMode() {
        refreshItems()

        selectedIndex = mode.includes("windows")
            ? Math.min(1, itemCount - 1)
            : 0
    }

    property var items: shownItems
    property int itemCount: Math.max(1, shownItems.length)

    property int maxColumns: 6
    property int tileWidth: 320
    property int tileHeight: 180
    property int gap: 8
    property int margin: 12

    property int availableWidth: Math.floor(floatingWidget.width * 0.75) - margin * 2

    property int columns: Math.max(1, Math.min(
        maxColumns,
        itemCount,
        Math.floor((availableWidth + gap) / (tileWidth + gap))
    ))

    property int rows: Math.ceil(itemCount / columns)

    function next() {
        if (openedThisHold) {
            openedThisHold = false
            return
        }

        selectedIndex = (selectedIndex + 1) % itemCount
    }

    function previous() {
        if (openedThisHold) {
            openedThisHold = false
            return
        }

        selectedIndex = (selectedIndex - 1 + itemCount) % itemCount
    }

    function accept() {
        if (!visible) return
        
        const item = items[selectedIndex]
        if (!item) return

        if (mode.includes("windows")) {
            item.wayland.activate()
            touchWindow(item)

            Qt.callLater(() => {
                froot.centerCursorOnWindow(item.address)                
            })
            
            // moveCursorToToplevelCenter(item)
        } else if (mode.includes("workspaces")) {
            Hyprland.dispatch(`workspace ${item.id}`)
        } else if (mode === "screens") {
            Hyprland.dispatch(`focusmonitor ${item.name}`)
        }

        accepted()
    }

    implicitWidth: Math.max(1, Math.min(
        floatingWidget.width * 0.75,
        columns * (tileWidth + gap) + margin * 2
    ))

    implicitHeight: Math.max(1, Math.min(
        floatingWidget.height * 0.7,
        rows * (tileHeight + gap) + margin * 2
    ))

    anchor.rect.x: floatingWidget.width / 2 - width / 2
    anchor.rect.y: floatingWidget.height / 2 - height / 2

    visible: shouldShow && openedOnThisScreen
    color: "transparent"

    Rectangle {
        id: rect
        anchors.fill: parent

        opacity: altTab.requestedVisible ? 1 : 0
        scale: altTab.requestedVisible ? 1 : 0.96
        transformOrigin: Item.Center

        Behavior on opacity {
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 140
                easing.type: Easing.OutCubic
            }
        }

        onOpacityChanged: {
            if (!altTab.requestedVisible && opacity <= 0.01)
                altTab.shouldShow = false
        }

        color: Qt.alpha(Theme.panelElevated, 0.5)
        border.color: Qt.lighter(Theme.panelElevated, 2)
        border.width: 2
        radius: 8

        Column {
            anchors.centerIn: parent
            spacing: altTab.gap

            Repeater {
                model: altTab.rows

                delegate: Row {
                    required property int index

                    spacing: altTab.gap

                    property int startIndex: index * altTab.columns
                    property int remaining: altTab.itemCount - startIndex
                    property int rowCount: Math.min(altTab.columns, remaining)

                    anchors.horizontalCenter: parent.horizontalCenter

                    Repeater {
                        model: rowCount

                        delegate: Rectangle {
                            id: item
                            required property int index

                            property int globalIndex: startIndex + index
                            property bool selected: globalIndex === altTab.selectedIndex

                            property var modelData: altTab.items[startIndex + index]

                            property bool isToplevel: modelData?.title !== undefined
                            property bool isWorkspace: modelData?.id !== undefined && modelData?.name !== undefined
                            property bool isScreen: modelData?.name !== undefined && modelData?.width !== undefined

                            width: altTab.tileWidth
                            height: altTab.tileHeight

                            color: Theme.panel
                            radius: 8

                            border.width: selected ? 3 : 0
                            border.color: Theme.accent

                            Item {
                                anchors.fill: parent
                                anchors.margins: 8
                                clip: true

                                ScreencopyView {
                                    anchors.fill: parent
                                    captureSource:
                                        (item.isWorkspace
                                            ? null
                                            : item.isToplevel
                                                ? item.modelData.wayland
                                                : item.modelData) ?? null
                                    antialiasing: true
                                    smooth: true
                                    live: true
                                }
                            }

                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.margins: 8

                                height: 32
                                color: "#99000000"

                                Text {
                                    anchors.fill: parent
                                    anchors.margins: 6

                                    text: item.modelData?.title ?? item.modelData?.name ?? "Unknown"

                                    color: "white"
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                Hazard {
                                    visible: item.selected
                                    anchors.fill: parent
                                    opacity: 0.075
                                    speed: 3600
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}