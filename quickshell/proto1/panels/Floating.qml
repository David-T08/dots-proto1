import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

import "../popups/AltTab"

Item {
    id: froot

    property bool altTabVisible: false
    property string altTabMode: "windows"

    signal centerCursorOnWindow(string address)
    signal altTabNext()
    signal altTabPrevious()
    signal altTabAccept()
    signal altTabSwitchMode()
                                
    IpcHandler {
        target: "floating"
    
        function alttab(cmd: string, mode: string) {
            cmd = cmd || "next"
            mode = mode || "windows"
        
            if (cmd === "next") {
                altTabMode = mode
                altTabVisible = true
                froot.altTabNext()
            } else if (cmd === "previous") {
                altTabMode = mode
                altTabVisible = true
                froot.altTabPrevious()
            } else if (cmd === "accept") {
                froot.altTabAccept()
                altTabVisible = false
            } else if (cmd === "hide") {
                altTabVisible = false
            } else if (cmd == "mode") {
                altTabMode = mode
                altTabVisible = true
                froot.altTabSwitchMode()
            }
        }
    
        function reload() {
            Quickshell.reload(true)
        }
    }

    Process {
        id: centerCursorProc

        function run(address) {
            command = [
                "sh",
                "-c",
                `${Quickshell.shellDir}/other/scripts/cursor_window_center.sh '${address}'`
            ]
            running = true
        }
    }

    onCenterCursorOnWindow: address => {
        centerCursorProc.run(address)
    }

    Variants {
        model: Quickshell.screens
    
        PanelWindow {
            id: floatingWidget
            required property ShellScreen modelData
            screen: modelData
    
            WlrLayershell.namespace: "qs-floating-overlay"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore 
            
            color: "transparent"
    
            anchors.bottom: true
            anchors.left: true
            anchors.right: true
    
            implicitHeight: floatingWidget.screen.height - 50
    
            mask: Region {
                item: floatingWidget
            }

            AltTab {
                id: altTabPopup
                anchor.window: floatingWidget

                requestedVisible: froot.altTabVisible
                mode: froot.altTabMode

                onAccepted: froot.altTabVisible = false
                
                Connections {
                    target: froot
            
                    function onAltTabNext() {
                        altTabPopup.next()
                    }
            
                    function onAltTabPrevious() {
                        altTabPopup.previous()
                    }

                    function onAltTabAccept() {
                        altTabPopup.accept()
                    }

                    function onAltTabSwitchMode() {
                        altTabPopup.switchMode()
                    }
                }
            }
        }
    }
}