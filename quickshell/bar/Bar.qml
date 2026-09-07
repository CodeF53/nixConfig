import Quickshell
import Quickshell.Hyprland
import QtQuick

import qs.bar.power
import qs.bar.clock
import qs.bar.calendar
import qs.bar.tray
import qs.bar.brightness
import qs.bar.notification

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
    }

    screen: {
        // hack until Quickshell.screens[a].serialNumber actually returns something other than ""
        // https://github.com/quickshell-mirror/quickshell/issues/903
        const target = {
            cassietop: "...",
            cassiebox: "Dell Inc. AW2725Q 29Q05B4",
        }[Quickshell.env("HOSTNAME")]
        const name = Hyprland.monitors.values.find(m => m.description === target)?.name
        return Quickshell.screens.find(s => s.name === name)
    }
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
