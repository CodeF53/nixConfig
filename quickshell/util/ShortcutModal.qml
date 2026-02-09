import Quickshell
import Quickshell.Hyprland
import QtQuick

PanelWindow {
    id: panel
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    focusable: true
    color: "transparent"

    property alias shortcutName: shortcut.name
    visible: false
    GlobalShortcut {
        id: shortcut
        onPressed: panel.visible = true
    }
    MouseArea {
        anchors.fill: parent
        onPressed: panel.visible = false
    }
    Shortcut {
        sequence: "Escape"
        onActivated: panel.visible = false
    }
    
    property alias windowWidth: window.width
    property alias windowHeight: window.height
    default property alias content: window.data
    GradientBorder {
        id: window
        anchors.centerIn: parent
    }
}
