import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls

PanelWindow {
    id: launcher
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    focusable: true
    color: "transparent"

    visible: false
    GlobalShortcut {
        name: "launcher"
        onPressed: launcher.visible = true
    }

    readonly property string query: searchBox.text
    readonly property bool queryIsEmpty: /^[=!]?$/.test(query)
    readonly property bool queryIsCalc: query[0] === "="
    readonly property bool queryIsDuck: !queryIsCalc && query.includes("!")
    readonly property var appResults: {
        if (queryIsEmpty || queryIsDuck || queryIsCalc)
            return [];
        const term = query.toLowerCase();
        return DesktopEntries.applications.values // comments are added here to prevent qmlls from putting this all on one line
        .filter(entry => entry.name.toLowerCase().includes(term)) //
        .sort((a, b) => a.name.localeCompare(b.name)); // TODO: sort by usage frequency
    }

    // every 2 hours update currency exchange rates
    Timer {
        interval: 2 * 60 * 60 * 1000 // 2 hours
        running: true
        repeat: true
        onTriggered: Quickshell.execDetached(["qalc", "-exrates", "1+1"]) // 1+1 so it exits immediately instead of going into interactive mode
    }
    Process {
        id: math
        property string result: ""
        function calc() {
            if (launcher.queryIsEmpty)
                return;
            math.command = ["qalc", "-t", launcher.query.slice(1)];
            math.running = true;
        }
        stdout: StdioCollector {
            onStreamFinished: math.result = this.text
        }
    }
    Timer {
        id: mathDebounce
        interval: 100
        repeat: false
        onTriggered: math.calc()
    }
    onQueryChanged: {
        math.result = "";
        if (query[0] === "=") // not using queryIsCalc because this runs before that updates
            mathDebounce.restart();
    }

    function exit() {
        visible = false;
        searchBox.text = "";
    }
    function launchApp() {
        appResultsList.currentItem.modelData.execute();
        exit();
    }

    Rectangle {
        id: fancyBorder
        anchors.fill: launcherBox
        anchors.margins: -2
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#74c7ec"
            }
            GradientStop {
                position: 1
                color: "#89b4fa"
            }
        }
    }
    Rectangle {
        id: launcherBox
        color: "#1e1e2e"
        implicitWidth: 400
        implicitHeight: 300
        anchors.centerIn: parent
        TextField {
            id: searchBox
            focus: true
            implicitWidth: launcherBox.width
            background: Rectangle {
                color: "#313244"
            }
            color: "white"
            placeholderText: "search..."
            placeholderTextColor: "#a6adc8"

            Keys.onUpPressed: appResultsList.decrementCurrentIndex()
            Keys.onDownPressed: appResultsList.incrementCurrentIndex()
            Keys.onEscapePressed: launcher.exit()
            onAccepted: {
                if (launcher.queryIsDuck) {
                    Quickshell.execDetached(["xdg-open", `https://unduck.link/?q=${encodeURIComponent(query)}`]);
                } else if (launcher.queryIsCalc) {
                    if (math.result === "") return;
                    Quickshell.execDetached(["wl-copy", math.result]);
                } else {
                    launcher.launchApp();
                }
                launcher.exit();
            }
        }
        Text {
            id: tutorialText
            visible: queryIsEmpty || queryIsDuck
            anchors.centerIn: parent
            color: "#a6adc8"
            font.family: "Mochie Iosevka"
            text: {
                if (launcher.queryIsDuck)
                    return "enter => open duckbang in browser\n  !w - wikipedia\n  !yt - youtube\n  !mdn - mozilla developer network";
                if (launcher.queryIsCalc)
                    return "enter => copy result of expression";
                return "type to search for apps\n\nactions:\n  ^= - math & unit conversions\n  !\\w+ - duckbang";
            }
        }
        Text {
            id: mathOutput
            visible: !launcher.queryIsDuck && launcher.queryIsCalc
            anchors.centerIn: parent
            color: "white"
            font.family: "Mochie Iosevka"
            text: math.result
        }
        ListView {
            id: appResultsList
            visible: !launcher.queryIsDuck && !launcher.queryIsCalc
            anchors {
                top: searchBox.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            model: launcher.appResults
            clip: true
            delegate: AppEntry {}
        }
    }
}
