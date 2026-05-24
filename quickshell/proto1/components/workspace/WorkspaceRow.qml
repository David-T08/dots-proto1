import QtQuick
import QtQml

import Quickshell.Hyprland

import "../.."

Row {
    required property HyprlandMonitor monitor
    
    id: workspaceRow
    spacing: 6

    Repeater {
        model: Hyprland.workspaces

        delegate: WorkspaceButton {
            required property HyprlandWorkspace modelData

            visible: (workspaceRow.monitor?.id == modelData.monitor?.id) && (modelData.toplevels.values.length > 0 || modelData.focused)
            workspace: modelData
        }
    }
}