import QtQuick
import Quickshell

import ".."
import "../.."

Brackets {
    id: root

    height: parent.height
    
    contentWidth: Math.ceil(content.implicitWidth)
    contentHeight: Math.ceil(parent.height)

    horizontalPadding: 36

    Item {
        id: wrapper

        width: content.implicitWidth
        height: parent.height

        Hazard {
            anchors.fill: parent
            anchors.margins: -root.horizontalPadding

            speed: 10000
            
            z: -1
            opacity: 0.05

            color: Theme.special
        }

        Column {
            id: content
    
            topPadding: 2
            
            Rectangle {
                implicitWidth: time.implicitWidth + 20
                implicitHeight: time.implicitHeight
    
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"//Qt.lighter(Theme.panelElevated, 1.2)
   
                Text {
                    id: time
        
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
            
                    text: sroot.clock.date.toLocaleTimeString(
                        Qt.locale(),
                        "HH:mm:ss"
                    )
                    color: Theme.text 
                    
                    font.pixelSize: 16
                    font.family: ibmPlexMono.name
                }
            }
    
            Text {
                id: user
    
                horizontalAlignment: Text.AlignLeft
        
                text: "/home/" + Quickshell.env("USER") + " • ARCH"  
                color: Theme.text 
                
                font.pixelSize: 12
                font.family: ibmPlexMonoBold.name
                font.bold: true
            }
        }
    }

    Component.onCompleted: openAnim.start()
    
    SequentialAnimation {
        id: openAnim

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "revealHeight"
                to: 1.0
                duration: 400
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: root
                property: "opacity"
                to: 1
                duration: 400
            }
        }

        NumberAnimation {
            target: root
            property: "revealWidth"
            to: 1.0
            duration: 850
            easing.type: Easing.OutCubic
        }
    }
}