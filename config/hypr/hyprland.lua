local hypr = os.getenv("HOME") .. "/.config/hypr"
package.path = hypr .. "/?.lua;" .. package.path

require("hyprland.env")
require("hyprland.general")
require("hyprland.animations")
require("hyprland.rules")
require("hyprland.execs")
require("hyprland.keybinds")

-- Machine-specific overrides (monitors, devices); ignored by git
pcall(require, "local")
