pragma Singleton

import Quickshell
import QtQml

Singleton {
    id: root

    property real monitorWidth: 1920
    property real referenceWidth: 1920
    property real minScale: 0.85
    property real maxScale: 1.25

    readonly property real scale: Math.max(
        minScale,
        Math.min(maxScale, monitorWidth / referenceWidth)
    )

    function px(value: real): int {
        return Math.round(value * scale)
    }

    property QtObject bar: QtObject {
        property int height: root.px(40)
        property int margins: root.px(8)
        property int spacing: root.px(8)
        property int radius: root.px(12)
    }

    property QtObject iconSize: QtObject {
        property int xs: root.px(12)
        property int sm: root.px(16)
        property int md: root.px(20)
        property int lg: root.px(24)
        property int xl: root.px(32)
        property int x2l: root.px(40)
        property int x3l: root.px(48)
    }

    property QtObject fontSize: QtObject {
        property int xs: root.px(10)
        property int sm: root.px(12)
        property int md: root.px(14)
        property int lg: root.px(16)
        property int xl: root.px(20)
        property int x2l: root.px(24)
        property int x3l: root.px(30)
        property int x4l: root.px(36)
        property int x5l: root.px(48)
    }

    property QtObject spacing: QtObject {
        property int xs: root.px(2)
        property int sm: root.px(4)
        property int md: root.px(8)
        property int lg: root.px(12)
        property int xl: root.px(16)
        property int x2l: root.px(24)
        property int x3l: root.px(32)
    }

    property QtObject radius: QtObject {
        property int sm: root.px(4)
        property int md: root.px(8)
        property int lg: root.px(12)
        property int xl: root.px(16)
        property int x2l: root.px(24)
        property int full: 999
    }
}
