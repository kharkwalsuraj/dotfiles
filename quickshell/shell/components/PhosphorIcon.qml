import QtQuick
import qs.shell.conf

Text {
    id: root

    enum Weight {
        Thin,
        Light,
        Regular,
        Bold,
        Fill,
        Duotone
    }

    property string glyph: ""
    property int size: 22
    property color iconColor: Colors.md3.on_surface
    property int weight: PhosphorIcon.Weight.Regular

    readonly property string weightName: {
        switch (root.weight) {
        case PhosphorIcon.Weight.Thin:    return "Phosphor-Thin"
        case PhosphorIcon.Weight.Light:   return "Phosphor-Light"
        case PhosphorIcon.Weight.Regular: return "Phosphor"
        case PhosphorIcon.Weight.Bold:    return "Phosphor-Bold"
        case PhosphorIcon.Weight.Fill:    return "Phosphor-Fill"
        case PhosphorIcon.Weight.Duotone: return "Phosphor-Duotone"
        default:                          return "Phosphor"
        }
    }

    text: root.glyph

    font.family: root.weightName
    font.pixelSize: root.size

    color: root.iconColor

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    renderType: Text.NativeRendering
}
