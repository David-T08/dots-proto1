import QtQml
import QtQuick

import Quickshell

import "panels"

Variants {
    model: Quickshell.screens

    Scope {
        id: root
        
        required property var modelData
        property var screen: modelData

        TopBar {
            modelData: root.screen
            screen: root.screen
            id: topbar
        }
    }
}