import QtQuick
import qs.shell.conf

Rectangle {
    id: root

    implicitWidth: 1
    implicitHeight: 16

    color: Colors.md3.outline_variant

    property int thickness: 1
    property int length: 16
    property bool vertical: true

    width: vertical ? thickness : length
    height: vertical ? length : thickness

    radius: Math.min(width, height) / 2
}
