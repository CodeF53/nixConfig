import Quickshell
import QtQuick

Text {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
    color: "white"
    text: Qt.formatDateTime(clock.date, "h:mmAP M-d dddd").toLowerCase()
}
