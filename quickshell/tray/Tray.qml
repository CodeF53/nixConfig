import Quickshell
import QtQuick
import Quickshell.Services.SystemTray

Item {
    implicitWidth: trayRow.width
    implicitHeight: trayRow.height
    anchors.verticalCenter: parent.verticalCenter

    Row {
        id: trayRow
        spacing: 2
        Repeater {
            model: SystemTray.items
            TrayItem {}
        }
    }
}
