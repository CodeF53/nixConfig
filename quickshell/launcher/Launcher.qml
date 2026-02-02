import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

import qs.util

ShortcutModal {
    id: modal
    windowWidth: 400
    windowHeight: 300
    shortcutName: "launcher"

    readonly property string query: search.text
    readonly property bool queryIsEmpty: /^[=!]?$/.test(query)
    readonly property bool queryIsCalc: query[0] === "="
    readonly property bool queryIsDuck: !queryIsCalc && query.includes("!")
    readonly property var appResults: {
        if (queryIsEmpty || queryIsDuck || queryIsCalc)
            return [];
        const term = query.toLowerCase();
        return DesktopEntries.applications.values // comments are added here to prevent qmlls from putting this all on one line
        .filter(entry => entry.name.toLowerCase().includes(term)) //
        .sort((a, b) => (db.get(b.id) - db.get(a.id)) || a.name.localeCompare(b.name));
    }

    FileView {
        id: dbFile
        path: Qt.resolvedUrl("./launchCounts.json")
        onLoadFailed: writeAdapter()
        JsonAdapter {
            id: db
            property var count: ({})
            function get(id) {
                return count[id] ?? 0;
            }
        }
    }
    function launchApp(entry) {
        entry.execute();
        db.count[entry.id] = db.get(entry.id) + 1;
        dbFile.writeAdapter(); // it doesnt detect the write so we have to manually do this and this is cleaner than doing it in a way that it detects the write
        modal.visible = false;
    }

    Process {
        id: math
        property string result: ""
        function calc() {
            if (modal.queryIsEmpty)
                return;
            math.command = ["qalc", "-t", modal.query.slice(1)];
            math.running = true;
        }
        stdout: StdioCollector {
            onStreamFinished: math.result = this.text
        }
    }
    Timer {
        id: mathDebounce
        interval: 100
        onTriggered: math.calc()
    }
    onQueryChanged: {
        math.result = "";
        if (query[0] === "=") // not using queryIsCalc because this runs before that updates
            mathDebounce.restart();
    }

    onVisibleChanged: {
        if (modal.visible) {
            Quickshell.execDetached(["qalc", "-exrates", "1+1"]); // 1+1 so it exits immediately instead of going into interactive mode
            search.forceActiveFocus();
        }
        search.text = "";
    }

    TextField {
        id: search
        focus: true
        implicitWidth: parent.width
        placeholderText: "search..."

        Keys.onUpPressed: appResultsList.decrementCurrentIndex()
        Keys.onDownPressed: appResultsList.incrementCurrentIndex()
        onAccepted: {
            if (modal.queryIsDuck) {
                Quickshell.execDetached(["xdg-open", `https://unduck.link/?q=${encodeURIComponent(query)}`]);
            } else if (modal.queryIsCalc) {
                if (math.result === "")
                    return;
                Quickshell.execDetached(["wl-copy", math.result]);
            } else {
                modal.launchApp(appResultsList.currentItem.modelData);
            }
            modal.visible = false;
        }
    }
    Text {
        id: tutorialText
        visible: modal.queryIsEmpty || modal.queryIsDuck
        anchors.centerIn: parent
        color: "#a6adc8"
        font.family: "Mochie Iosevka"
        text: {
            if (modal.queryIsDuck)
                return "enter => open duckbang in browser\n  !w - wikipedia\n  !yt - youtube\n  !mdn - mozilla developer network";
            if (modal.queryIsCalc)
                return "enter => copy result of expression";
            return "type to search for apps\n\nactions:\n  ^= - math & unit conversions\n  !\\w+ - duckbang";
        }
    }
    Text {
        id: mathOutput
        visible: !modal.queryIsDuck && modal.queryIsCalc
        anchors.centerIn: parent
        color: "white"
        font.family: "Mochie Iosevka"
        text: math.result
    }
    ListView {
        id: appResultsList
        visible: !modal.queryIsDuck && !modal.queryIsCalc
        anchors {
            top: search.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        model: modal.appResults
        clip: true
        delegate: AppEntry {}
    }
}
