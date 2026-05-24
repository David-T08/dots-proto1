import QtQuick

import "../utils/brackets.mjs" as BracketUtils
import ".."

Item {
    id: root

    default property alias content: contentItem.data

    property color bracketColor: Theme.bracketDim
    property real lineWidth: 2
    property real cornerLength: 6

    property real horizontalPadding: 32

    property real revealHeight: 0.0
    property real revealWidth: 0.0

    property real contentWidth: 0
    property real contentHeight: 0

    implicitWidth: contentWidth + horizontalPadding * 2 + lineWidth
    implicitHeight: contentHeight + lineWidth

    width: implicitWidth
    clip: true

    Item {
        id: contentClip
        visible: root.revealHeight >= 1

        anchors.verticalCenter: parent.verticalCenter

        width: (root.width - root.lineWidth) * root.revealWidth
        height: root.height

        x: (root.width - width) / 2
        
        clip: true

        Item {
            id: contentItem
    
            width: root.contentWidth
            height: root.contentHeight

            anchors.centerIn: parent
        }
    }

    Canvas {
        id: bracketCanvas
        anchors.fill: parent
        z: 10

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            ctx.strokeStyle = root.bracketColor
            ctx.lineWidth = root.lineWidth
            ctx.lineCap = "butt"

            const rh = root.revealHeight
            const rw = root.revealWidth

            ctx.beginPath()

            if (rh < 1) {
                BracketUtils.runHeightReveal(ctx, rh, height, width, root.lineWidth)
            } else if (rw < 1) {
                BracketUtils.runWidthReveal(ctx, rw, height, width, root.lineWidth, root.cornerLength)
            } else {
                BracketUtils.drawFull(ctx, height, width, root.lineWidth, root.cornerLength)
            }
            
            ctx.stroke()
        }

        Connections {
            target: root

            function onRevealWidthChanged() { bracketCanvas.requestPaint() }
            function onRevealHeightChanged() { bracketCanvas.requestPaint() }
            function onBracketColorChanged() { bracketCanvas.requestPaint() }
            function onLineWidthChanged() { bracketCanvas.requestPaint() }
            function onCornerLengthChanged() { bracketCanvas.requestPaint() }
            function onImplicitWidthChanged() { bracketCanvas.requestPaint() }
            function onImplicitHeightChanged() { bracketCanvas.requestPaint() }
        }
    }
}