import Quickshell
import QtQuick
import Quickshell.Services.SystemTray

MouseArea {
    id: trayItem
    required property SystemTrayItem modelData

    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onClicked: e => {
        switch (e.button) {
        case Qt.LeftButton:
            return modelData.activate();
        case Qt.RightButton:
            return menuAnchor.open();
        case Qt.MiddleButton:
            return modelData.secondaryActivate();
        }
    }

    implicitHeight: 16
    implicitWidth: 16
    Image {
        anchors.centerIn: parent
        anchors.fill: parent
        sourceSize {
            width: 16
            height: 16
        }
        source: {
            const icon = parent.modelData.icon;
            if (!icon.includes("?path="))
                return icon;
            const [name, path] = icon.split("?path=");
            return `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
        }
    }

    QsMenuAnchor {
        id: menuAnchor
        menu: trayItem.modelData.menu

        anchor.window: trayItem.QsWindow.window
        anchor.adjustment: PopupAdjustment.Flip | PopupAdjustment.Resize
        anchor.margins.top: 4

        anchor.onAnchoring: {
            const window = trayItem.QsWindow.window;
            const widgetRect = window.contentItem.mapFromItem(trayItem, 0, trayItem.height, trayItem.width, trayItem.height);
            menuAnchor.anchor.rect = widgetRect;
        }
    }
}
