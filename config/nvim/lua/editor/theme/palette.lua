-- Fallback base16 palette (Catppuccin Mocha accents on neutral black) and color helpers
local M = {}

---@alias Base16 table<string, string>

---@type Base16
M.fallback = {
    base00 = "#101010",
    base01 = "#181818",
    base02 = "#2A2A2A",
    base03 = "#737373",
    base04 = "#A3A3A3",
    base05 = "#D4D4D4",
    base06 = "#E8E8E8",
    base07 = "#B4BEFE",
    base08 = "#F38BA8",
    base09 = "#FAB387",
    base0A = "#F9E2AF",
    base0B = "#A6E3A1",
    base0C = "#94E2D5",
    base0D = "#89B4FA",
    base0E = "#CBA6F7",
    base0F = "#F2CDCD",
}

local function channels(hex) return tonumber(hex:sub(2, 3), 16) or 0, tonumber(hex:sub(4, 5), 16) or 0, tonumber(hex:sub(6, 7), 16) or 0 end

function M.blend(top, base, alpha)
    local t = { channels(top) }
    local b = { channels(base) }
    local out = "#"
    for i = 1, 3 do
        out = out .. ("%02X"):format(math.floor(t[i] * alpha + b[i] * (1 - alpha) + 0.5))
    end
    return out
end

function M.is_light(hex)
    local r, g, b = channels(hex)
    return (0.299 * r + 0.587 * g + 0.114 * b) > 127
end

return M
