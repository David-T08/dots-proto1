pragma Singleton

import QtQuick

QtObject {
    readonly property color background: "#0A0F14"
    readonly property color backgroundAlt: "#0D141B"

    readonly property color panel: "#101820"
    readonly property color panelElevated: "#17212B"
    readonly property color panelHover: "#1D2A36"

    readonly property color border: "#233243"
    readonly property color borderBright: "#35506B"

    readonly property color overlay: "#081018DD"
    readonly property color shadow: "#00000080"

    readonly property color primary: "#3DA9FC"
    readonly property color primaryHover: "#63BBFF"
    readonly property color primaryActive: "#8DD1FF"
    readonly property color primaryDim: "#1E6FAE"
    readonly property color primaryGlow: "#3DA9FC55"

    readonly property color accent: "#00E5A8"
    readonly property color accentHover: "#3DFFC2"
    readonly property color accentActive: "#7AFFD7"
    readonly property color accentDim: "#008A68"
    readonly property color accentGlow: "#00E5A855"

    readonly property color success: accent
    readonly property color successHover: accentHover
    readonly property color successActive: accentActive
    readonly property color successDim: accentDim
    readonly property color successGlow: accentGlow

    readonly property color warning: "#FFC857"
    readonly property color warningHover: "#FFD982"
    readonly property color warningActive: "#FFE7AE"
    readonly property color warningDim: "#A67D2A"
    readonly property color warningGlow: "#FFC85755"

    readonly property color danger: "#FF5A5F"
    readonly property color dangerHover: "#FF7B7F"
    readonly property color dangerActive: "#FFA0A3"
    readonly property color dangerDim: "#9B2D31"
    readonly property color dangerGlow: "#FF5A5F55"

    readonly property color special: "#A277FF"
    readonly property color specialHover: "#B999FF"
    readonly property color specialActive: "#D1BBFF"
    readonly property color specialDim: "#6842B0"
    readonly property color specialGlow: "#A277FF55"

    readonly property color text: "#EAF2F8"
    readonly property color textBright: "#FFFFFF"
    readonly property color textMuted: "#7D8FA3"
    readonly property color textDisabled: "#4C5B6B"

    readonly property color icon: "#A8C1D9"
    readonly property color iconActive: "#FFFFFF"

    readonly property color bracket: primary
    readonly property color bracketDim: primaryDim
    readonly property color bracketGlow: primaryGlow

    readonly property color workspaceActive: primary
    readonly property color workspaceOccupied: accent
    readonly property color workspaceEmpty: panelElevated
    readonly property color workspaceUrgent: danger

    readonly property color button: panelElevated
    readonly property color buttonHover: panelHover
    readonly property color buttonActive: primaryDim
    
    readonly property int radiusSmall: 3
    readonly property int radius: 6
    readonly property int radiusLarge: 10

    readonly property int spacingSmall: 4
    readonly property int spacing: 6
    readonly property int spacingLarge: 12

    readonly property int paddingSmall: 6
    readonly property int padding: 10
    readonly property int paddingLarge: 16
}