import Quickshell
import QtQuick
import Quickshell.Io

PanelWindow {
    id: statusIndicator
    implicitWidth: 128
    implicitHeight: 48

    // focus should never be given to this panel
    mask: Region {}

    FileView {
        path: `${Quickshell.env("HOME")}/.cache/hyprwhspr-rs/status.json`
        watchChanges: true
        onFileChanged: reload()
        JsonAdapter {
            id: status
            property string alt: ""
        }
    }
    visible: status.alt === "active" || status.alt === "processing"

    color: "transparent"
    Rectangle {
        anchors.fill: parent
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
        radius: parent.height
    }
    Rectangle {
        anchors {
            fill: parent
            margins: 2
        }
        radius: parent.height
        color: "#1e1e2e"
        
        MicWibbler {
            visible: status.alt === "active"
            anchors {
                fill: parent
                margins: 8
            }
        }
        Text {
            visible: status.alt === "processing"
            anchors.centerIn: parent
            text: "Processing..."
            color: "white"
        }
    }
}
