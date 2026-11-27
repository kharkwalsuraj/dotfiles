local hypr = os.getenv("HOME") .. "/.config/hypr"
package.path = hypr .. "/?.lua;" .. package.path

-- Re-read colors on every `hyprctl reload`
package.loaded["colors"] = nil
package.loaded["variables"] = nil

require("hyprland.env")
require("hyprland.general")
require("hyprland.animations")
require("hyprland.rules")
require("hyprland.execs")
require("hyprland.keybinds")

-- Machine-specific overrides (monitors, devices); ignored by git
pcall(require, "local")
