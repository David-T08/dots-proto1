import Quickshell

import QtQuick
import QtQuick.Effects


Item {
    id: root
    
    property int tileOffset: 80
    property int speed: 400
    property bool animated: true
    property var color: "#FFFFFF"
    property bool mirror: false

    clip: true
    height: parent.height

    Image {
        id: hazard
        source: Quickshell.shellDir + "/assets/images/hazard.svg"
        fillMode: Image.Tile
    
        height: root.height
        width: root.width + root.tileOffset
    
        visible: false
        mirror: root.mirror
    
        NumberAnimation on x {
            from: -root.tileOffset
            to: 0
            duration: root.speed
            loops: Animation.Infinite
            running: root.animated
        }
    }

    MultiEffect {
        source: hazard
        anchors.fill: hazard

        blurEnabled: false
        shadowEnabled: false
        maskEnabled: false

        colorization: 1
        colorizationColor: root.color
    }
}