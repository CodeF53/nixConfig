import Quickshell
import Quickshell.Io
import QtQuick.Controls
import QtQuick

import qs.util

BarButton {
    id: brightnessButton
    icon: Qt.resolvedUrl("./sun.svg")
    mouseArea.onPressed: popup.open()

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
    
    Popup {
        id: popup
        y: 22
        width: brightnessSlider.implicitWidth + 16
        height: brightnessSlider.implicitHeight + 16
        
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
