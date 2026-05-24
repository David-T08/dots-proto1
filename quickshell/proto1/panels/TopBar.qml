import QtQuick
import Quickshell
import Quickshell.Wayland

import QtQuick.Effects

import "../components/workspace"
import "../components/centerInfo"
import "../components/systemtray"
import "../components/systeminfo"
import "../components/systemcontrol"
import "../components/musiccontrol"
import "../components"
import ".."

PanelWindow {
    id: topbar

    property var modelData

    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        left: true
        right: true
    }

    margins.left: 8
    margins.right: 8
    margins.top: 8

    implicitHeight: 42

    Rectangle {
        id: bar
        
        color: Theme.panel
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
        
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000022" }
                GradientStop { position: 0.5; color: "transparent" }
                GradientStop { position: 1.0; color: "#00000022" }
            }
        
            z: 1
        }

        // noise
        Item {
            anchors.fill: parent
            clip: true
            z: 1
        
            Image {
                id: noise
        
                width: parent.width + 128
                height: parent.height + 128
        
                source: "../assets/images/noise.png"
                fillMode: Image.Tile
        
                opacity: 0.15
                smooth: false
                mipmap: false
        
                property real offset: 0
        
                x: offset
                y: offset
        
                NumberAnimation on offset {
                    from: 0
                    to: -128
                    duration: 12000
                    loops: Animation.Infinite
                    running: true
                }
            }
        }

        // scan
        Item {
            anchors.fill: parent
            clip: true
            z: 0
        
            Rectangle {
                id: scanline
        
                width: parent.width
                height: 1
                color: Theme.special
                opacity: 0.025
        
                layer.enabled: true
                layer.effect: MultiEffect {
                    blurEnabled: true
                    blur: 0.6
                    brightness: 0.2
                }
        
                SequentialAnimation on y {
                    loops: Animation.Infinite
        
                    NumberAnimation {
                        from: -4
                        to: bar.height + 4
                        duration: 7000
                        easing.type: Easing.InOutSine
                    }
        
                    PauseAnimation {
                        duration: 2500
                    }
                }
            }
        
            Rectangle {
                width: parent.width
                height: 6
                y: scanline.y - 3
                color: Theme.primaryGlow
                opacity: 0.06
            }
        }


        Workspaces {
            id: workspaceinfo
            z: 2
        }

        MusicControl {
            anchors.left: parent.left
            anchors.leftMargin: workspaceinfo.width + 12
            z: 2
        }
        
        CenterInfo {
            anchors.horizontalCenter: parent.horizontalCenter
            z: 2
        }
        
        SystemTray {
            anchors.rightMargin: systeminfo.width + systemcontroltray.width + 24
            anchors.right: parent.right
            z: 2
        }

        SystemInfo {
            id: systeminfo
            anchors.margins: systemcontroltray.width + 12
            anchors.right: parent.right
            z: 2
        }

        SystemControlTray {
            id: systemcontroltray
            anchors.right: parent.right
            z: 2
        }
    }
}