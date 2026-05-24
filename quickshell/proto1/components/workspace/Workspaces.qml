import QtQuick
import Quickshell.Hyprland

import ".."
import "../.."

Brackets {
    id: brackets

    height: bar.height
    bracketColor: Theme.bracketDim
    
    anchors.verticalCenter: parent.verticalCenter

    contentWidth: Math.ceil(content.implicitWidth)
    contentHeight: Math.ceil(content.implicitHeight)

    horizontalPadding: 12

    cornerLength: 6
    lineWidth: 2

    property var monitor: Hyprland.monitorFor(topbar.modelData)
    property var workspace: monitor?.activeWorkspace
    property var focusedWindow: workspace?.toplevels?.values?.find(
        t => t.activated
    )

    property string lastTitle: ""
    property string lastAppId: ""

    function updateLastWindow() {
        const windows = workspace?.toplevels?.values ?? []

        if (focusedWindow) {
            lastTitle = focusedWindow.title ?? ""
            lastAppId = focusedWindow.wayland?.appId ?? ""
        } else if (windows.length === 0) {
            lastTitle = ""
            lastAppId = ""
        }
    }

    SequentialAnimation {
        id: openAnim

        ParallelAnimation {
            NumberAnimation {
                target: brackets
                property: "revealHeight"
                to: 1.0
                duration: 400
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: brackets
                property: "opacity"
                to: 1
                duration: 400
            }
        }

        NumberAnimation {
            target: brackets
            property: "revealWidth"
            to: 1.0
            duration: 850
            easing.type: Easing.OutCubic
        }
    }

    Row {
        id: content

        spacing: 8
        
        WorkspaceRow {
            id: workspaceRow
            monitor: Hyprland.monitorFor(topbar.modelData)
        }

        Rectangle {
            visible: lastTitle !== ""
            width: 1
            height: workspaceRow.height

            color: Theme.textMuted
            opacity: 0.6
        }
    
        Column {
            Text {
                text: lastTitle ?? ""
        
                color: Theme.text
                font.family: ibmPlexMonoBold.name
                font.bold: true
                font.pixelSize: 12
        
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 240)
            }

            Text {
                text: lastAppId ?? ""
        
                color: Theme.textMuted
                font.family: ibmPlexMonoBold.name
                font.bold: true
                font.pixelSize: 10
        
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 240)
            }
        }
    }

    Connections {
        target: Hyprland

        function onActiveToplevelChanged() { updateLastWindow() }
    }

    onFocusedWindowChanged: updateLastWindow()
    onWorkspaceChanged: updateLastWindow()

    Component.onCompleted: {
        openAnim.start()

        updateLastWindow()
    }
}