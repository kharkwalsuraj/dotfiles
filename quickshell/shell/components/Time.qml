import Quickshell
import QtQuick
import qs.shell.conf

Column {
    id: root

    spacing: 1

    property date currentDate: new Date()

    Text {
        text: Qt.formatDateTime(root.currentDate, "hh:mm AP")
        color: Colors.md3.on_surface
        font.family: "Google Sans Flex"
        font.pixelSize: Appearance.fontSize.sm
        font.weight: Font.Medium
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        text: Qt.formatDateTime(root.currentDate, "ddd, dd/MM")
        color: Colors.md3.on_surface_variant
        font.family: "Google Sans Flex"
        font.pixelSize: Appearance.fontSize.xs
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentDate = new Date()
    }
}
