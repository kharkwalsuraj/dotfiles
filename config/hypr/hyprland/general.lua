local vars = require("variables")

-- Highest resolution at the highest refresh rate, scale picked by Hyprland
hl.monitor({ output = "", mode = vars.monitorMode, position = "auto", scale = vars.monitorScale })

hl.gesture({ fingers = vars.gestureFingers, direction = "swipe", action = "move" })
hl.gesture({ fingers = vars.workspaceSwipeFingers, direction = "vertical", action = "workspace" })

hl.config({
    general = {
        layout        = "scrolling",
        allow_tearing = false,
        gaps_in       = vars.windowGapsIn,
        gaps_out      = vars.windowGapsOut,
        border_size   = vars.windowBorderSize,
        col           = {
            active_border   = vars.activeBorderColor,
            inactive_border = vars.inactiveBorderColor,
        },
    },

    scrolling = {
        column_width = vars.columnWidth,
    },

    decoration = {
        rounding = vars.windowRounding,

        blur = { enabled = false },

        -- Shadows are disabled for tiled windows in rules.lua
        shadow = {
            enabled      = true,
            range        = vars.shadowRange,
            render_power = vars.shadowRenderPower,
            color        = vars.shadowColor,
        },
    },

    input = {
        kb_layout    = vars.keyboardLayout,
        repeat_delay = vars.keyRepeatDelay,
        repeat_rate  = vars.keyRepeatRate,
        follow_mouse = 1,

        touchpad = {
            natural_scroll       = vars.touchpadNaturalScroll,
            disable_while_typing = vars.touchpadDisableTyping,
            scroll_factor        = vars.touchpadScrollFactor,
        },
    },

    misc = {
        font_family             = vars.font,
        disable_hyprland_logo   = true,
        force_default_wallpaper = 0,
        background_color        = vars.backgroundColor,
        focus_on_activate       = true,
        middle_click_paste      = false,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms  = true,
    },
})
