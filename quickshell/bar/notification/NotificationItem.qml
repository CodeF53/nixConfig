import QtQuick
import Quickshell.Services.Notifications

import qs.util

GradientBorder {
    id: notification
    required property Notification modelData
    color: "#1e1e2e"
    width: parent.width
    implicitHeight: notificationCore.implicitHeight

    function timeSinceCreated() {
        return Date.now() - modelData.createdAt;
    }
    property bool tease: notification.timeSinceCreated() < 10000
    Timer {
        interval: Math.max(1, 10000 - notification.timeSinceCreated())
        running: notification.tease
        onTriggered: notification.tease = false
    }
    visible: tray.open || notification.tease

    Image {
        id: img
        anchors {
            left: parent.left
            margins: 4
        }
        anchors.verticalCenter: parent.verticalCenter
        height: 48
        width: 48
        visible: notification.modelData.image !== ''
        source: {
            const icon = notification.modelData.image;
            if (!icon.includes("?path="))
                return icon;
            const [name, path] = icon.split("?path=");
            return `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
        }
    }
    Column {
        id: notificationCore
        padding: 4
        anchors {
            left: img.visible ? img.right : parent.left
            right: closeButton.left
            margins: 4
        }
        Text {
            color: "white"
            text: notification.modelData.summary
        }
        Text {
            color: "white"
            text: notification.modelData.body
            font.pixelSize: 12
            wrapMode: Text.WordWrap
            width: parent.width
        }
        Row {
            spacing: 4
            Repeater {
                model: notification.modelData.actions
                MouseArea {
                    required property NotificationAction modelData
                    cursorShape: Qt.PointingHandCursor
                    onPressed: modelData.invoke()
                    implicitWidth: action.implicitWidth
                    implicitHeight: action.implicitHeight
                    Text {
                        id: action
                        text: modelData.text
                        font.pixelSize: 12
                        color: "#89dceb"
                    }
                }
            }
        }
    }
    MouseArea {
        id: closeButton
        implicitWidth: 24
        implicitHeight: 24
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        cursorShape: Qt.PointingHandCursor
        onPressed: notification.modelData.dismiss()
        Image {
            anchors.centerIn: parent
            source: "./x.svg"
        }
    }
}
