import Quickshell
import QtQuick
import Quickshell.Services.Notifications

MouseArea {
    id: tray
    implicitHeight: 16
    implicitWidth: 16
    cursorShape: Qt.PointingHandCursor
    anchors.verticalCenter: parent.verticalCenter
    Image {
        source: "./bell.svg"
    }

    NotificationServer {
        id: notificationServer
        keepOnReload: true
        actionsSupported: true
        onNotification: notification => {
            notification.tracked = true;
        }
    }
    readonly property list<Notification> list: notificationServer.trackedNotifications.values
    readonly property int notificationCount: tray.list.length
    onNotificationCountChanged: {
        if (notificationCount === 0)
            notificationPopup.visible = false;
    }
    onPressed: {
        if (notificationCount > 0)
            notificationPopup.visible = !notificationPopup.visible;
    }

    Rectangle {
        visible: tray.notificationCount >= 1
        implicitWidth: count.implicitWidth
        implicitHeight: count.implicitHeight
        color: "#1e1e2e"
        anchors.right: parent.right
        Text {
            id: count
            text: tray.notificationCount
            color: "#89dceb"
            font.pixelSize: 8
            font.bold: true
        }
    }

    PopupWindow {
        id: notificationPopup
        anchor.window: root
        anchor.rect.x: root.width - width
        anchor.rect.y: root.height + 2
        implicitWidth: notificationCol.implicitWidth + 1
        implicitHeight: notificationCol.implicitHeight + 1
        color: "transparent"
        Column {
            id: notificationCol
            spacing: 2
            Repeater {
                model: tray.list
                NotificationItem {}
            }
        }
    }
}
