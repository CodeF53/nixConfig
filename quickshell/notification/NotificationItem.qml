import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Rectangle {
    id: notification
    required property Notification modelData
    color: "#1e1e2e"
    implicitWidth: 300
    implicitHeight: notificationCore.implicitHeight
    visible: notification.modelData !== null
    Row {
        padding: 2
        spacing: 4
        Image {
            anchors.verticalCenter: parent.verticalCenter
            height: Math.min(notificationCore.implicitHeight, 48)
            width: Math.min(notificationCore.implicitHeight, 48)
            visible: notification.modelData.image !== ''
            source: {
                const icon = notification.modelData.image
                if (!icon.includes("?path=")) return icon
                const [name, path] = icon.split("?path=")
                return `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`
            }
        }
        Column {
            id: notificationCore
            Text {
                color: "white"
                text: notification.modelData.summary
            }
            Text {
                color: "white"
                text: notification.modelData.body
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                width: 200
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
                            text: parent.modelData.text
                            font.pixelSize: 12
                            color: "#89dceb"
                        }
                    }
                }
            }
        }
    }
    MouseArea {
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