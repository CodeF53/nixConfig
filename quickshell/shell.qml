import Quickshell
import QtQuick

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }
  

  implicitHeight: 16
  color: "#1e1e2e";
  
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
  Text {
    color: "white";
    text: Qt.formatDateTime(clock.date, "h:mmAP M-d dddd").toLowerCase()
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
  }
}