-- Color helpers
local M = {}

---@alias Base16 table<string, string>

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
