import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.shell.services

// Draws the wallpaper on every screen and regenerates the system colors whenever it changes.
// Change it from a terminal: qs -c hyprland-shell ipc call wallpaper set /path/to/image.jpg
Scope {
    id: root

    readonly property string path: Config.appearance.image !== "" ? `${Config.appearance.dir}/${Config.appearance.image}` : ""

    onPathChanged: colorsTimer.restart()

    // Waits for changes to settle (the IPC sets dir and image together), and for a running generation to finish
    Timer {
        id: colorsTimer

        interval: 250
        onTriggered: {
            if (colors.running)
                restart();
            else if (root.path !== "")
                colors.running = true;
        }
    }

    Connections {
        target: Config.appearance

        function onModeChanged() {
            colorsTimer.restart();
        }

        function onSchemeChanged() {
            colorsTimer.restart();
        }
    }

    IpcHandler {
        target: "wallpaper"

        function set(path: string): void {
            const slash = path.lastIndexOf("/");
            Config.appearance.dir = path.substring(0, slash);
            Config.appearance.image = path.substring(slash + 1);
        }

        function get(): string {
            return root.path;
        }
    }

    Process {
        id: colors

        command: ["bash", Quickshell.shellPath("shell/scripts/colors/apply-colors.sh"), root.path, Config.appearance.mode, Config.appearance.scheme, Quickshell.statePath("colors.json")]
        stderr: StdioCollector {
            onStreamFinished: if (text !== "") console.warn("[wallpaper] " + text)
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            required property var modelData

            screen: modelData
            color: "black"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "hyprland-shell-wallpaper"

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Image {
                id: image

                anchors.fill: parent
                source: root.path
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: false

                // Old wallpaper zooms in and fades out, the new one fades in while zooming back to normal
                Behavior on source {
                    enabled: image.source.toString() !== ""

                    SequentialAnimation {
                        ScriptAction {
                            script: fadeIn.stop()
                        }

                        ParallelAnimation {
                            NumberAnimation {
                                target: image
                                property: "opacity"
                                to: 0
                                duration: 300
                                easing.type: Easing.InCubic
                            }

                            NumberAnimation {
                                target: image
                                property: "scale"
                                to: 1.06
                                duration: 300
                                easing.type: Easing.InCubic
                            }
                        }

                        PropertyAction {
                            target: image
                            property: "source"
                        }
                    }
                }

                ParallelAnimation {
                    id: fadeIn

                    NumberAnimation {
                        target: image
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 600
                        easing.type: Easing.OutCubic
                    }

                    NumberAnimation {
                        target: image
                        property: "scale"
                        from: 1.06
                        to: 1
                        duration: 600
                        easing.type: Easing.OutCubic
                    }
                }

                // Error is included so a wallpaper that fails to load does not leave the screen black
                onStatusChanged: if (status === Image.Ready || status === Image.Error) fadeIn.restart()
            }
        }
    }
}
