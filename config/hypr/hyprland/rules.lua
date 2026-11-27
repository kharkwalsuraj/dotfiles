-- Tiled windows get no shadow; floating ones keep it
hl.window_rule({ match = { float = false }, no_shadow = true })

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ match = { class = ".*" }, idle_inhibit = "fullscreen" })

-- Floating windows open centered (Xwayland popups excluded)
hl.window_rule({ match = { float = true, xwayland = false }, center = true })

local function float(match, size)
    hl.window_rule({ match = match, float = true, center = true, size = size })
end

local dialog_size = "(monitor_w*0.6) (monitor_h*0.65)"
local utility_size = "(monitor_w*0.45) (monitor_h*0.5)"

-- App-made modal dialogs
hl.window_rule({ match = { modal = true }, float = true, center = true })

-- File pickers: portal windows and toolkit-native dialogs
local portal_classes = {
    "xdg-desktop-portal-gtk",
    "xdg-desktop-portal-gnome",
    "org.freedesktop.impl.portal.desktop.kde",
}
for _, class in ipairs(portal_classes) do
    float({ class = class }, dialog_size)
end

local dialog_titles = {
    "^(Open Files?|Open Folders?|Select (a )?Files?|Select (a )?Folders?).*$",
    "^(Save( As| File| Image)?|Export( As)?|File Upload|Choose (a )?(File|Files|Folder|Image|wallpaper)).*$",
    "^(Library|Rename|Properties|Confirm to replace files|File Operation Progress).*$",
    "^.* wants to (save|open).*$",
}
for _, title in ipairs(dialog_titles) do
    float({ title = title }, dialog_size)
end

-- Utilities that belong in a floating window
local utility_classes = {
    "pavucontrol", "org.pulseaudio.pavucontrol", "com.saivert.pwvucontrol",
    "nm-connection-editor", "blueman-manager", "nwg-look",
    "org.gnome.FileRoller", "file-roller", "system-config-printer",
}
for _, class in ipairs(utility_classes) do
    float({ class = "^(" .. class .. ")$" }, utility_size)
end

float({ class = "kcm_.*" })
float({ class = "^(zenity|yad|wev)$" })
float({ title = "^(Authentication Required|Polkit.*)$" })
float({ class = "^(zen|zen-browser)$", title = "^Extension: .*" })

-- Picture-in-picture
hl.window_rule({
    match             = { title = "^[Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture.*$" },
    float             = true,
    pin               = true,
    keep_aspect_ratio = true,
    size              = "(monitor_w*0.25) (monitor_h*0.25)",
    move              = "(monitor_w*0.98-window_w) (monitor_h*0.97-window_h)",
})
