import Quickshell
import QtQuick
import Quickshell.Io

import qs.util

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
    
    GradientBorder {
        anchors.fill: parent
        radius: parent.height
        
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
