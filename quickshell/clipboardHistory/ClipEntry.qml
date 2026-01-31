import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: entry
    required property var modelData
    required property int index

    implicitHeight: entry.modelData.isImg ? image.height : text.implicitHeight
    anchors {
        left: parent?.left
        right: parent?.right
    }
    color: ListView.isCurrentItem ? "#181825" : "transparent"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: entry.ListView.view.currentIndex = entry.index
        cursorShape: Qt.PointingHandCursor
        onPressed: modal.copyEntry(entry.modelData.id)
    }

    Process {
        id: getPNGData
        running: entry.modelData.isImg
        command: ["sh", "-c", `cliphist decode ${entry.modelData.id} | base64 -w0`]
        stdout: StdioCollector {
            onStreamFinished: image.source = `data:image/png;base64,${this.text.trim()}`
        }
    }

    Text {
        id: text
        visible: !entry.modelData.isImg
        anchors {
            left: parent.left
            right: parent.right
            margins: 4
            verticalCenter: parent.verticalCenter
        }
        text: entry.modelData.content
        color: "white"
    }
    Image {
        id: image
        anchors {
            margins: 4
            verticalCenter: parent.verticalCenter
        }
        visible: entry.modelData.isImg
        height: Math.min(entry.modelData.imgSize?.[1] ?? 0, 100)
        fillMode: Image.PreserveAspectFit
    }
}
