import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import Quickshell.Services.UPower
import qs.shell.conf

ProgressBar {
    id: root

    readonly property bool available: UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery
    readonly property bool isCharging: UPower.displayDevice.state === UPowerDeviceState.Charging
    readonly property real batteryPercentage: Math.max(0, Math.min(1, UPower.displayDevice.percentage))
    readonly property int displayedPercentage: Math.round(batteryPercentage * 100)
    readonly property color highlightColor: batteryPercentage <= lowBatteryThreshold && !isCharging ? lowColor : normalColor
    readonly property color trackColor: Qt.rgba(highlightColor.r, highlightColor.g, highlightColor.b, trackOpacity)

    property int valueBarWidth: 30
    property int valueBarHeight: Appearance.iconSize.sm
    property real lowBatteryThreshold: 0.15
    property color normalColor:  Colors.md3.on_surface
    property color lowColor: Colors.md3.error
    property real trackOpacity: 0.28

    from: 0
    to: 1
    value: batteryPercentage
    padding: 0

    implicitWidth: valueBarWidth
    implicitHeight: valueBarHeight
    visible: available

    background: Item {
        implicitWidth: root.valueBarWidth
        implicitHeight: root.valueBarHeight
    }

    // Source layer: a pill-shaped track with a dynamic fill.
    contentItem: Rectangle {
        id: indicatorShape
        anchors.fill: parent
        radius: height / 2
        color: root.trackColor
        visible: false

        Rectangle {
            id: progressFill
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: parent.width * root.visualPosition
            color: root.highlightColor
        }
    }

    // Mask containing the text and optional charging bolt.
    // These shapes become transparent cut-outs in the final indicator.
    property Item textMask: Row {
        width: root.width
        height: root.height
        anchors.centerIn: parent

        PhosphorIcon {
            visible: root.isCharging
            anchors.verticalCenter: parent.verticalCenter
            size: Appearance.iconSize.xs
            iconColor: "white"
            weight: PhosphorIcon.Weight.Fill
            glyph: "\uE2DE"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.displayedPercentage.toString()
            color: "white"
            font.family: "Google Sans Flex"
            font.pixelSize: 12
            font.weight: root.displayedPercentage >= 100 ? Font.Medium : Font.DemiBold
            renderType: Text.QtRendering
        }
    }

    // First clip the capsule to its rounded outline.
    OpacityMask {
        id: roundedMask
        visible: false
        anchors.fill: parent
        source: indicatorShape
        maskSource: Rectangle {
            width: indicatorShape.width
            height: indicatorShape.height
            radius: indicatorShape.radius
        }
    }

    // Then invert the text mask to punch the percentage out of the fill.
    OpacityMask {
        anchors.fill: parent
        source: roundedMask
        invert: true
        maskSource: root.textMask
    }
}
