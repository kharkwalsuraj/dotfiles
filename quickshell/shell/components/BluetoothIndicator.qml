import QtQuick
import Quickshell
import Quickshell.Io
import qs.shell.conf

Item {
    id: root

    enum State { EnabledConnected, EnabledDisconnected, Disabled, Unavailable }

    property int iconSize: Appearance.iconSize.sm
    property color iconColor: Colors.md3.on_surface
    property int state: BluetoothIndicator.State.Unavailable

    implicitWidth: bluetoothIcon.implicitWidth
    implicitHeight: bluetoothIcon.implicitHeight

    function refresh() {
        adapterProcess.running = true
    }

    // Read adapter power and availability.
    Process {
        id: adapterProcess

        command: ["bluetoothctl", "show"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim()

                if (!output || !output.includes("Controller ")) {
                    root.state = BluetoothIndicator.State.Unavailable
                    return
                }

                if (output.includes("Powered: no")) {
                    root.state = BluetoothIndicator.State.Disabled
                    return
                }

                if (output.includes("Powered: yes")) {
                    deviceProcess.running = true
                } else {
                    root.state = BluetoothIndicator.State.Unavailable
                }
            }
        }
    }

    // Check whether any Bluetooth device is connected.
    Process {
        id: deviceProcess

        command: ["bluetoothctl", "devices", "Connected"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim()

                root.state = output.length > 0
                    ? BluetoothIndicator.State.EnabledConnected
                    : BluetoothIndicator.State.EnabledDisconnected
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    PhosphorIcon {
        id: bluetoothIcon

        anchors.centerIn: parent

        size: root.iconSize
        iconColor: root.iconColor
        weight: PhosphorIcon.Weight.Bold

        glyph: {
            switch (root.state) {
            case BluetoothIndicator.State.EnabledConnected:
                return "\uE0DC";

            case BluetoothIndicator.State.EnabledDisconnected:
                return "\uE0DA";

            case BluetoothIndicator.State.Disabled:
                return "\uE0E0";

            default:
                return "\uE0DE";
            }
        }
    }
}
