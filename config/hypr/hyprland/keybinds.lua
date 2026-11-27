local vars = require("variables")

local bind = hl.bind

local function run(cmd)
    return hl.dsp.exec_cmd(cmd)
end

local function layout(msg)
    return hl.dsp.layout(msg)
end

local locked = { locked = true, repeating = true }
local mouse = { mouse = true }

-- Apps
bind("SUPER + Return", run(vars.terminal))
bind("SUPER + B", run(vars.browser))
bind("SUPER + E", run(vars.fileManager))
bind("SUPER + Space", run(vars.launcher))

-- Window actions
bind("SUPER + Q", hl.dsp.window.close())
bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind("SUPER + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
bind("SUPER + V", hl.dsp.window.float())
bind("SUPER + P", hl.dsp.window.pin())
bind("SUPER + mouse:272", hl.dsp.window.drag(), mouse)
bind("SUPER + mouse:273", hl.dsp.window.resize(), mouse)

-- Exit Hyprland
bind("SUPER + SHIFT + E", hl.dsp.exit())

-- Focus: the layout's own message scrolls the strip without leaving
-- fullscreen or maximized state
bind("SUPER + bracketleft", layout("focus l"))
bind("SUPER + bracketright", layout("focus r"))
bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))

-- Columns and windows
bind("SUPER + SHIFT + bracketleft", layout("swapcol l"))
bind("SUPER + SHIFT + bracketright", layout("swapcol r"))
bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "up" }))
bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "down" }))
bind("SUPER + comma", layout("consume"))
bind("SUPER + period", layout("expel"))

-- Workspaces
for i = 1, 9 do
    bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e-1" }))
bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))

-- Media
local sink = "@DEFAULT_AUDIO_SINK@"
bind("XF86AudioRaiseVolume", run("wpctl set-mute " .. sink .. " 0; wpctl set-volume -l 1 " .. sink .. " " .. vars.volumeStep .. "%+"), locked)
bind("XF86AudioLowerVolume", run("wpctl set-volume " .. sink .. " " .. vars.volumeStep .. "%-"), locked)
bind("XF86AudioMute", run("wpctl set-mute " .. sink .. " toggle"), locked)
bind("XF86AudioMicMute", run("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)
bind("XF86MonBrightnessUp", run("brightnessctl set " .. vars.brightnessStep .. "%+"), locked)
bind("XF86MonBrightnessDown", run("brightnessctl set " .. vars.brightnessStep .. "%-"), locked)
bind("XF86AudioPlay", run("playerctl play-pause"), locked)
bind("XF86AudioNext", run("playerctl next"), locked)
bind("XF86AudioPrev", run("playerctl previous"), locked)
