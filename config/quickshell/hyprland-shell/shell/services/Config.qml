pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// System-wide settings, stored as JSON in Quickshell.stateDir (~/.local/state/hyprland-shell/config.json).
// Edit the file or assign to a property; both ways are saved and picked up live.
// File edits are applied once they stop for a moment, so half-typed changes are never used.
Singleton {
    id: root

    property alias appearance: adapter.appearance

    Timer {
        id: reloadTimer

        interval: 400
        onTriggered: file.reload()
    }

    Timer {
        id: writeTimer

        interval: 200
        onTriggered: file.writeAdapter()
    }

    FileView {
        id: file

        path: Quickshell.statePath("config.json")
        watchChanges: true

        onFileChanged: reloadTimer.restart()
        onAdapterUpdated: writeTimer.restart()
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound)
                writeAdapter();
        }

        adapter: JsonAdapter {
            id: adapter

            property JsonObject appearance: JsonObject {
                // File name inside dir, e.g. "forest.jpg"
                property string image: ""
                // Folder holding the wallpapers (also the source for a future slideshow)
                property string dir: Quickshell.env("HOME") + "/Pictures/Wallpapers"
                // tonal_spot, vibrant, expressive, neutral, monochrome, fidelity, content, rainbow, fruit_salad
                property string scheme: "neutral"
                // dark or light
                property string mode: "dark"
            }
        }
    }
}
