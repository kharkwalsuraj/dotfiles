import QtQuick
import Quickshell
import Quickshell.Io
import qs.shell.conf

Item {
    id: root

    enum State {
        WifiConnected,
        WifiDisconnected,
        WifiOff,
        EthernetConnected,
        EthernetDisconnected,
        NoConnection
    }

    property int iconSize: Appearance.iconSize.sm
    property color iconColor: Colors.md3.on_surface

    property int state: NetworkIndicator.State.NoConnection
    readonly property bool wifiEnabled: wifiRadio.enabled

    implicitWidth: networkIcon.implicitWidth
    implicitHeight: networkIcon.implicitHeight

    function refresh() {
        wifiRadio.running = true
        deviceProcess.running = true
    }

    // Is Wi-Fi enabled?
    Process {
        id: wifiRadio
        property bool enabled: true

        command: ["nmcli", "-t", "radio", "wifi"]

        stdout: StdioCollector {
            onStreamFinished: {
                wifiRadio.enabled = text.trim() === "enabled"
            }
        }
    }

    // Determine active device and connection state.
    Process {
        id: deviceProcess

        command: [ "nmcli", "-t", "-f", "TYPE,STATE", "device", "status" ]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim()
                const lines = output ? output.split("\n") : []

                let wifiConnected = false
                let ethernetConnected = false
                let wifiPresent = false
                let ethernetPresent = false

                for (const line of lines) {
                    const fields = line.split(":")
                    const type = fields[0]
                    const status = fields[1]

                    if (type === "wifi") {
                        wifiPresent = true
                        if (status === "connected")
                            wifiConnected = true
                    }

                    if (type === "ethernet") {
                        ethernetPresent = true
                        if (status === "connected")
                            ethernetConnected = true
                    }
                }

                if (ethernetConnected) {
                    root.state = NetworkIndicator.State.EthernetConnected
                } else if (wifiConnected) {
                    root.state = NetworkIndicator.State.WifiConnected
                } else if (!root.wifiEnabled && wifiPresent) {
                    root.state = NetworkIndicator.State.WifiOff
                } else if (wifiPresent) {
                    root.state = NetworkIndicator.State.WifiDisconnected
                } else if (ethernetPresent) {
                    root.state = NetworkIndicator.State.EthernetDisconnected
                } else {
                    root.state = NetworkIndicator.State.NoConnection
                }
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
        id: networkIcon

        anchors.centerIn: parent

        size: root.iconSize
        iconColor: root.iconColor
        weight: PhosphorIcon.Weight.Fill

        glyph: {
            switch (root.state) {
            case NetworkIndicator.State.WifiConnected:
                return "\uE4EA"

            case NetworkIndicator.State.WifiDisconnected:
                return "\uE4F4"

            case NetworkIndicator.State.WifiOff:
                return "\uE4F2"

            case NetworkIndicator.State.EthernetConnected:
                return "\uEDDE"

            case NetworkIndicator.State.EthernetDisconnected:
                return "\uEDDA"

            default:
                return "\uEDDC"
            }
        }
    }
}
