import QtQuick
import Quickshell.Io

Rectangle {
    id: calendarWidget
    property var upcomingEvents: []
    readonly property var currentEvent: {
        if (calendarWidget.upcomingEvents instanceof Error)
            return calendarWidget.upcomingEvents;
        return calendarWidget.upcomingEvents.find(event => Date.now() < event.endMs);
    }

    Process {
        id: fetchEvents
        workingDirectory: (new URL(Qt.resolvedUrl("eventFetcher"))).pathname
        command: ["bun", "index.ts"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const stdout = this.text.trim();
                if (stdout === '')
                    return;
                try {
                    calendarWidget.upcomingEvents = JSON.parse(stdout);
                    console.log(JSON.stringify(calendarWidget.upcomingEvents, null, 2));
                } catch (e) {
                    console.error(e);
                    calendarWidget.upcomingEvents = e;
                }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                const stderr = this.text.trim();
                if (stderr === '')
                    return;
                console.error(stderr);
                calendarWidget.upcomingEvents = new Error(stderr);
                eventTiming.text = "(run `bun eventFetcher/index.ts`)";
            }
        }
    }
    Timer {
        interval: 600000 // 10 minutes
        running: true
        repeat: true
        onTriggered: fetchEvents.running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            const event = calendarWidget.currentEvent;
            if (event instanceof Error) {
                eventTitle.text = event.toString();
                return;
            }
            if (event === undefined) {
                eventTitle.text = "No events";
                eventTiming.text = "";
                return;
            }
            eventTitle.text = event.title ?? "No Title";

            const now = Date.now();
            const eventStarted = event.startMs <= now;
            const ms = (eventStarted ? event.endMs : event.startMs) - now;
            eventTiming.setText({
                ms,
                eventStarted
            });
        }
    }

    color: "#45475a"
    height: eventDetails.implicitHeight
    width: eventDetails.implicitWidth
    Row {
        id: eventDetails
        spacing: 2
        padding: 2
        Text {
            id: eventTitle
            color: "white"
            text: "Loading Events"
            width: Math.min(implicitWidth, 250)
            elide: Text.ElideRight
            font.pixelSize: 14
        }
        Text {
            id: eventTiming
            anchors.verticalCenter: parent.verticalCenter
            color: "#bac2de"
            text: ""
            font.pixelSize: 10

            function setText({
                ms,
                eventStarted
            }) {
                const h = Math.floor(ms / 36e5);
                const m = Math.floor(ms / 6e4 % 60);
                const time = (h ? h + 'hr' : '') + (m ? m + 'm' : '') || Math.floor(ms / 1e3) + 's';

                this.text = `(${eventStarted ? 'ends in' : 'in'} ${time})`;
            }
        }
    }

    Process {
        id: linkOpener
    }
    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onPressed: {
            const event = calendarWidget.currentEvent;
            if (event !== undefined && !(event instanceof Error)) {
                linkOpener.command = ["xdg-open", event.link];
                linkOpener.running = true;
            }
        }
    }
}
