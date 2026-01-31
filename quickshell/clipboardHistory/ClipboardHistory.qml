import Quickshell
import Quickshell.Io
import QtQuick

import qs.util

ShortcutModal {
    id: modal
    windowWidth: 600
    windowHeight: 400
    shortcutName: "clipboardHistory"

    property var clipboard: []
    readonly property var clipboardFiltered: clipboard.filter(e => e.content.toLowerCase().includes(search.text.toLowerCase()))
    Process {
        id: getClipboard
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n");
                if (lines.length === 0)
                    return;
                const imgRegex = /^\d+\t\[\[ binary data \d+ \S+ png (\d+)x(\d+) ]]$/;
                modal.clipboard = lines.map(line => {
                    const tabIndex = line.indexOf("\t");
                    const imgSize = imgRegex.exec(line)?.slice(1)?.map(Number);
                    return {
                        id: line.slice(0, tabIndex),
                        content: line.slice(tabIndex + 1),
                        imgSize,
                        isImg: imgSize !== undefined
                    };
                });
            }
        }
    }
    onVisibleChanged: {
        if (modal.visible) {
            getClipboard.running = true;
            search.forceActiveFocus();
        }
        search.text = "";
    }
    function copyEntry(id) {
        Quickshell.execDetached(["sh", "-c", `cliphist decode ${id} | wl-copy`]);
        modal.visible = false;
    }

    TextField {
        id: search
        focus: true
        implicitWidth: parent.width
        placeholderText: "search..."
        Keys.onUpPressed: clipboardList.decrementCurrentIndex()
        Keys.onDownPressed: clipboardList.incrementCurrentIndex()
        onAccepted: modal.copyEntry(clipboardList.currentItem.modelData.id)
    }
    ListView {
        id: clipboardList
        anchors {
            top: search.bottom
            bottom: parent.bottom
        }
        implicitWidth: parent.width
        model: modal.clipboardFiltered
        clip: true
        delegate: ClipEntry {}
    }
}
