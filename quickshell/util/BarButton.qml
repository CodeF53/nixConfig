import QtQuick

Item {
    implicitHeight: 16
    implicitWidth: 16
    anchors.verticalCenter: parent.verticalCenter

    property alias mouseArea: mouseArea
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
    Rectangle {
        anchors.fill: parent
        color: mouseArea.containsMouse ? "#11111b" : "transparent"
    }
    property alias icon: icon.source
    Image {
        anchors.centerIn: parent
        anchors.fill: parent
        sourceSize {
            width: 16
            height: 16
        }
        id: icon
    }
}
