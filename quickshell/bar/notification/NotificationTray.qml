import QtQuick
import QtQuick.Controls
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
        }
    }
    readonly property list<Notification> list: notificationServer.trackedNotifications.values
    readonly property int notificationCount: tray.list.length
    property bool open: false
    onNotificationCountChanged: {
        if (notificationCount === 0)
            notificationPopup.close();
    }
    mouseArea.onPressed: {
        if (notificationCount > 0)
            notificationPopup.open();
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

    // Popup {
    //     width: 300
    //     height: 300
    //     y: 22
    //     background: Rectangle { color: "green"; anchors.fill: parent }
    //     visible: true
    // }

    Popup {
        id: notificationPopup
        popupType: Popup.Window
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        y: 22 - 16
        width: Math.max(notificationList.implicitWidth, 1)
        height: Math.max(notificationList.implicitHeight, 1)
        background: null
        Column {
            id: notificationList
            width: 300
            spacing: 2
            padding: 8
            Repeater {
                model: tray.list.slice(-10).reverse()
                NotificationItem {}
            }
        }
    }
}
