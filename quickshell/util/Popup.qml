import QtQuick
import QtQuick.Controls

Popup {
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    popupType: Popup.Window

    topInset: -2
    bottomInset: -2
    leftInset: -2
    rightInset: -2
    background: GradientBorder {}

    default property alias content: contentItem.data
    contentItem: Item {
        anchors.fill: parent
        id: contentItem
    }
}
