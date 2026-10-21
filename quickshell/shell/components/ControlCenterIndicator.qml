import QtQuick
import QtQuick.Layouts
import qs.shell.conf
import Quickshell.Widgets

Rectangle {
    id: root

    implicitWidth: controls.implicitWidth + Appearance.spacing.md
    implicitHeight: Appearance.iconSize.lg

    radius: height / 2
    color: "transparent"

    RowLayout {
        id: controls

        anchors.centerIn: parent
        spacing: 4

        NetworkIndicator {
            Layout.alignment: Qt.AlignVCenter
        }

        BluetoothIndicator {
            Layout.alignment: Qt.AlignVCenter
        }

        BatteryIndicator {
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
