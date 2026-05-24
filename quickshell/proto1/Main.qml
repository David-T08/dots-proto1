import QtQml
import QtQuick

import Quickshell

import "panels"

Variants {
    model: Quickshell.screens

    TopBar {
        id: topbar
        screen: modelData

        // AltTab {
        //     anchor.window: topbar
        //     visible: true
        // }
    }
}