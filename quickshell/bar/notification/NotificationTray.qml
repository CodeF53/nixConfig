import Quickshell
import QtQuick
import Quickshell.Services.Notifications

import qs.util

BarButton {
    id: tray
    icon: Qt.resolvedUrl("./bell.svg")

    NotificationServer {
        id: notificationServer
        keepOnReload: true
        actionsSupported: true
        onNotification: notification => {
            notification.tracked = true;
            notification.createdAt = Date.now();
        }
    }
    readonly property list<Notification> list: notificationServer.trackedNotifications.values
    readonly property int notificationCount: tray.list.length
    property bool open: false
    onNotificationCountChanged: {
        if (notificationCount === 0)
            tray.open = false;
    }
    mouseArea.onPressed: {
        if (notificationCount > 0)
            tray.open = !tray.open;
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
        anchor.rect.y: root.height + 8
        implicitHeight: 1080 - anchor.rect.y
        implicitWidth: notificationList.implicitWidth + 1
        color: "transparent"
        mask: Region {
            item: notificationList
        }
        visible: true

        Column {
            id: notificationList
            width: 300
            spacing: 2
            Repeater {
                model: tray.list.slice().reverse() // the .slice prevents the array from being duplicated
                NotificationItem {}
            }
        }
    }
}
