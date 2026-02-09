import Quickshell
import QtQuick
import Quickshell.Io

import qs.util

BarButton {
    id: powerMenuButton
    mouseArea.onPressed: popup.open()
    icon: Qt.resolvedUrl("./power.svg")
    
    Popup {
        id: popup
        y: 22
        implicitWidth: powerItems.implicitWidth
        implicitHeight: powerItems.implicitHeight
        
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
                    hoverEnabled: true
                    onPressed: Quickshell.execDetached(["systemctl", powerEntry.modelData.action])
                    implicitWidth: 90
                    implicitHeight: text.implicitHeight
                    Rectangle {
                        anchors.fill: parent
                        color: powerEntry.containsMouse ? "#11111b" : "transparent"
                    }
                    Image {
                        id: icon
                        source: powerEntry.modelData.icon
                        width: 16
                        height: 16
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        anchors {
                            left: icon.right
                            margins: 2
                        }
                        id: text
                        text: powerEntry.modelData.name
                        color: "white"
                    }
                }
            }
        }
    }
}
