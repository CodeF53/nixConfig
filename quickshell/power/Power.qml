import Quickshell
import QtQuick
import Quickshell.Io

MouseArea {
    id: powerMenuButton
    implicitHeight: 16
    implicitWidth: 16
    cursorShape: Qt.PointingHandCursor
    onPressed: powerPopup.visible = !powerPopup.visible
    anchors.verticalCenter: parent.verticalCenter
    Image {
        source: "./power.svg"
    }
    PopupWindow {
        id: powerPopup
        anchor.window: root
        anchor.rect.x: 0
        anchor.rect.y: root.height
        implicitWidth: powerItems.implicitWidth
        implicitHeight: powerItems.implicitHeight
        color: "#1e1e2e"
        MouseArea {
            id: powerPopupMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onExited: powerPopup.visible = false
        }
        Column {
            id: powerItems
            padding: 2
            Repeater {
                model: [
                    {
                        name: "shutdown",
                        action: "poweroff",
                        icon: "./power.svg"
                    },
                    {
                        name: "reboot",
                        action: "reboot",
                        icon: "./restart.svg"
                    },
                    {
                        name: "sleep",
                        action: "suspend",
                        icon: "./bed.svg"
                    },
                ]
                MouseArea {
                    id: powerEntry
                    required property var modelData
                    cursorShape: Qt.PointingHandCursor
                    Process {
                        id: powerAction
                        command: ["systemctl", powerEntry.modelData.action]
                    }
                    onPressed: powerAction.running = true
                    implicitWidth: 90
                    implicitHeight: text.implicitHeight
                    Row {
                        spacing: 2
                        Image {
                            source: powerEntry.modelData.icon
                            width: 16
                            height: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            id: text
                            text: powerEntry.modelData.name
                            color: "white"
                        }
                    }
                }
            }
        }
    }
}
