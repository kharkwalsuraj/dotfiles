local colors = require("colors")

return {
    -- Apps
    terminal              = "kitty",
    browser               = "zen-browser",
    fileManager           = "thunar",
    launcher              = "fuzzel",

    -- Monitor
    monitorMode           = "highres@highrr",
    monitorScale          = "auto",

    -- Keyboard
    keyboardLayout        = "us",
    keyRepeatDelay        = 250,
    keyRepeatRate         = 35,

    -- Touchpad
    touchpadNaturalScroll = true,
    touchpadDisableTyping = true,
    touchpadScrollFactor  = 0.3,
    gestureFingers        = 3,
    workspaceSwipeFingers = 4,

    -- Layout
    columnWidth           = 0.75,

    -- Gaps
    windowGapsIn          = 6,
    windowGapsOut         = 12,

    -- Window styling (rounding follows the Material Design 3 medium shape and GNOME's 12px)
    windowRounding        = 12,
    windowBorderSize      = 2,
    activeBorderColor     = "rgb(" .. colors.primary .. ")",
    inactiveBorderColor   = "rgb(" .. colors.outlineVariant .. ")",

    -- Shadow (applied to floating windows only)
    shadowRange           = 24,
    shadowRenderPower     = 3,
    shadowColor           = "rgba(00000080)",

    -- Misc
    backgroundColor       = "rgb(" .. colors.surface .. ")",
    font                  = "Google Sans Flex",
    cursorTheme           = "Bibata-Modern-Classic",
    cursorSize            = 24,
    volumeStep            = 5,
    brightnessStep        = 5,
}
