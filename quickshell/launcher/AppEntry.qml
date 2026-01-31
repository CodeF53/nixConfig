import Quickshell
import QtQuick

Rectangle {
    id: app
    required property DesktopEntry modelData
    required property int index

    implicitHeight: row.implicitHeight
    anchors {
        left: parent?.left
        right: parent?.right
    }
    color: ListView.isCurrentItem ? "#181825" : "transparent"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: app.ListView.view.currentIndex = app.index
        cursorShape: Qt.PointingHandCursor
        onPressed: modal.launchApp(app.modelData)
    }

    Row {
        id: row
        padding: 4
        spacing: 4
        Image {
            anchors.verticalCenter: parent.verticalCenter
            width: text.font.pixelSize
            height: width
            source: Quickshell.iconPath(app.modelData.icon)
        }
        Text {
            id: text
            anchors.verticalCenter: parent.verticalCenter
            text: app.modelData.name
            color: "white"
        }
    }
}
