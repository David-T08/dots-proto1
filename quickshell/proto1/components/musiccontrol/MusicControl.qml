import QtQuick
import Quickshell.Services.Mpris

import ".."
import "../.."

Brackets {
    id: musiccontrol

    height: parent.height
    
    contentWidth: Math.ceil(content.implicitWidth)
    contentHeight: Math.ceil(parent.height)

    horizontalPadding: 12
    
    Row {
        id: content
        spacing: 8

        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            width: 32
            height: 32
            color: Theme.panelElevated
            visible: albumArt.status !== Image.Ready
        
            Text {
                anchors.centerIn: parent
                text: "󰎆"
                font.family: "Hack Nerd Font"
                color: Theme.textMuted
            }
        }
        
        Image {
            id: albumArt
            
            width: 32
            height: 32
 
            source: sroot.mediaPlayer?.trackArtUrl ?? ""
            visible: albumArt.status === Image.Ready
            
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true

            smooth: true
            mipmap: true
            antialiasing: true
        }
        
        Column {
            Text {
                text: sroot.mediaPlayer?.trackTitle ?? "No media"
                color: Theme.text
                
                font.family: ibmPlexMonoBold.name
                font.bold: true
                font.pixelSize: 12
    
                width: Math.min(implicitWidth, 220)
                elide: Text.ElideRight
            }
    
            Text {
                text: sroot.mediaPlayer?.trackArtist ?? ""
                color: Theme.textMuted
                
                font.family: ibmPlexMono.name
                font.bold: true
                font.pixelSize: 10
    
                width: Math.min(implicitWidth, 220)
                elide: Text.ElideRight
            }
        }
    }

    Component.onCompleted: openAnim.start()
    
    SequentialAnimation {
        id: openAnim

        ParallelAnimation {
            NumberAnimation {
                target: musiccontrol
                property: "revealHeight"
                to: 1.0
                duration: 400
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: musiccontrol
                property: "opacity"
                to: 1
                duration: 400
            }
        }

        NumberAnimation {
            target: musiccontrol
            property: "revealWidth"
            to: 1.0
            duration: 850
            easing.type: Easing.OutCubic
        }
    }
}