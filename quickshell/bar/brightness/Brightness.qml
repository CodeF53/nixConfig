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
        id: getDisplayIndexesCassiebox
        running: Quickshell.env("HOSTNAME") === "cassiebox"
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
        id: getCurrentBrightnessCassiebox
        running: Quickshell.env("HOSTNAME") === "cassiebox"
        command: ["ddcutil", "getvcp", "10"]
        stdout: StdioCollector {
            onStreamFinished: {
                const [_, currentStr] = /current value = +(\d+)/.exec(this.text);
                brightnessSlider.value = Number.parseInt(currentStr);
            }
        }
    }

    Process {
        id: getCurrentBrightnessCassietop
        running: Quickshell.env("HOSTNAME") === "cassietop"
        command: ["bash", "-c", "echo $(( $(brightnessctl --device intel_backlight g) * 100 / $(brightnessctl --device intel_backlight m) ))"]
        stdout: StdioCollector {
            onStreamFinished: brightnessSlider.value = Number.parseInt(this.text)
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
            onValueChanged: {
                switch (Quickshell.env("HOSTNAME")) {
                case "cassiebox":
                    brightnessButton.displays.forEach(d => {
                        Quickshell.execDetached(["ddcutil", "setvcp", "10", brightnessSlider.value, `--display=${d}`]);
                    });
                    break;
                case "cassietop":
                    Quickshell.execDetached(["bash", "-c", `
                        test "$(sudo cat /sys/class/backlight/asus_screenpad/bl_power)" -ne 1 && brightnessctl --device asus_screenpad s ${brightnessSlider.value}%
                    `]);
                    Quickshell.execDetached(["brightnessctl", "--device", "intel_backlight", "s", `${Math.max(brightnessSlider.value, 1)}%`]);
                    break;
                }
            }
        }
    }
}
