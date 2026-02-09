import QtQuick

Rectangle {
    id: border
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
    default property alias content: contentItem.data
    Rectangle {
        radius: border.radius
        id: contentItem
        anchors {
            fill: parent
            margins: 2
        }
        color: "#1e1e2e"
    }
}
