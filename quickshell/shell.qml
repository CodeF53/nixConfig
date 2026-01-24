//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.tray
import qs.calendar
import qs.power
import qs.notification
import qs.brightness

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
    }

    screen: Quickshell.screens.find(s => s.name === "DP-4")
    implicitHeight: 16
    color: "#1e1e2e"

    Item {
        id: barLeft
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: barLeftRow.implicitHeight
        width: barLeftRow.implicitWidth
        Row {
            id: barLeftRow
            spacing: 4
            padding: 2
            Power {}
            Clock {}
            UpcomingEvent {}
        }
    }
    Item {
        id: barRight
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: barRightRow.implicitHeight
        width: barRightRow.implicitWidth
        Row {
            id: barRightRow
            spacing: 4
            padding: 2
            Tray {}
            Brightness {}
            NotificationTray {}
        }
    }
}
