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
    Rectangle {
        id: fancyBorder
        anchors.fill: window
        anchors.margins: -2
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#74c7ec"
            }
            GradientStop {
                position: 1
                color: "#89b4fa"
            }
        }
        MouseArea { 
            anchors.fill: parent
        }
    }
    Rectangle {
        id: window
        color: "#1e1e2e"
        anchors.centerIn: parent
    }
}
