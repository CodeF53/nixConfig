import Quickshell.Io
import QtQuick

Item {
    id: micWibbler
    property var cavaData: []
    readonly property int barCount: 20
    Process {
        id: cavaProc
        running: true
        command: ["sh", "-c", `
cava -p /dev/stdin <<EOF
    [general]
    bars = ${micWibbler.barCount}
    framerate = 15
    autosens = 1
    sensitivity = 150
    lower_cutoff_freq = 100
    higher_cutoff_freq = 8000
    [input]
    method = pulse
    source = $(pactl get-default-source)
    [output]
    channels = mono
    method = raw
    raw_target = /dev/stdout
    data_format = ascii
    ascii_max_range = 1000
    bar_delimiter = 59
    [smoothing]
    noise_reduction = 0.20
EOF`]
        stdout: SplitParser {
            onRead: data => micWibbler.cavaData = data.split(";").map(p => parseFloat(p.trim()) / 1000).filter(p => !isNaN(p));
        }
    }

    Row {
        anchors.fill: parent
        Repeater {
            model: micWibbler.barCount
            Rectangle {
                width: micWibbler.width / micWibbler.barCount
                height: Math.max((micWibbler.cavaData[index] ?? 0) * micWibbler.height, 1)
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                Behavior on height { NumberAnimation { duration: 50 } }
            }
        }
    }
}
