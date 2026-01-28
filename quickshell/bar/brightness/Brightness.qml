import Quickshell
import Quickshell.Io
import QtQuick.Controls
import QtQuick

MouseArea {
    id: brightnessButton
    implicitHeight: 16
    implicitWidth: 16
    cursorShape: Qt.PointingHandCursor
    onPressed: brightnessPopup.visible = !brightnessPopup.visible
    anchors.verticalCenter: parent.verticalCenter

    property var displays: []
    Process {
        id: getDisplayIndexes
        running: true
        command: ["ddcutil", "detect"]
        stdout: StdioCollector {
            onStreamFinished: {
                const dispPattern = /Display (\d+)/g;
                let match = dispPattern.exec(this.text);
                while (match !== null) {
                    brightnessButton.displays.push(match[1]);
                    match = dispPattern.exec(this.text);
                }
            }
        }
    }
    Process {
        id: getCurrentBrightness
        running: true
        command: ["ddcutil", "getvcp", "10"]
        stdout: StdioCollector {
            onStreamFinished: {
                const [_, currentStr] = /current value = +(\d+)/.exec(this.text);
                brightnessSlider.value = Number.parseInt(currentStr);
            }
        }
    }

    Image {
        source: "./sun.svg"
    }
    PopupWindow {
        id: brightnessPopup
        anchor.window: root
        anchor.rect.x: root.width - width
        anchor.rect.y: root.height
        implicitWidth: brightnessSlider.implicitWidth + 16
        implicitHeight: brightnessSlider.implicitHeight + 16
        color: "#1e1e2e"
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onExited: brightnessPopup.visible = false
            Slider {
                id: brightnessSlider
                anchors.centerIn: parent
                from: 0
                to: 100
                stepSize: 5
                live: false
                value: 50
                onValueChanged: brightnessButton.displays.forEach(d => {
                    Quickshell.execDetached(["ddcutil", "setvcp", "10", brightnessSlider.value, `--display=${d}`]);
                })
            }
        }
    }
}
