import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.shell.conf
import qs.shell.components

Variants {
    model: Quickshell.screens


    delegate: PanelWindow {
        required property var modelData

        Component.onCompleted: {
            console.log(modelData.width, modelData.height)
            Appearance.monitorWidth = 1920
        }

        implicitHeight: Appearance.bar.height
        color: Colors.md3.surface
        anchors { bottom: true; left: true; right: true; }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Appearance.bar.margins
            anchors.rightMargin: Appearance.bar.margins

            // TODO: left control
            Item {
                Layout.fillWidth: true
            }

            // Right control
            RowLayout {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Seprator {}
                ControlCenterIndicator {}
                Seprator {}
                Time {}
            }
        }

    }
}
