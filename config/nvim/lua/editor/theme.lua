-- Applies highlight groups from the base16 colors of an external theme JSON (its material and ansi entries are ignored),
-- falling back to editor.theme.palette. Reload from outside: nvim --server <socket> --remote-expr 'v:lua.reload_colors()'
local palette = require("editor.theme.palette")
local highlights = require("editor.theme.highlights")

local M = {}

M.path = vim.env.NVIM_COLORS_JSON or (vim.fn.stdpath("state") .. "/colors.json")

local function normalize_key(key) return (tostring(key):lower():gsub("[^%w]", "")) end

local function normalize(tbl)
    local out = {}
    for key, value in pairs(tbl) do
        out[normalize_key(key)] = value
    end
    return out
end

local function parse_hex(value)
    if type(value) ~= "string" then return nil end
    local digits = value:match("^#?(%x%x%x%x%x%x)$") or value:match("^#?(%x%x%x%x%x%x)%x%x$")
    return digits and ("#" .. digits:upper()) or nil
end

---@return table<string, any>
local function read_json()
    local file = io.open(M.path, "r")
    if not file then return {} end
    local ok, data = pcall(vim.json.decode, file:read("*a"))
    file:close()
    return (ok and type(data) == "table") and normalize(data) or {}
end

-- The fallback palette with every valid color of the JSON's base16 entry on top
---@return Base16 base16, boolean found
local function load_base16()
    local base16 = vim.deepcopy(palette.fallback)
    local source = read_json().base16
    local found = false
    if type(source) == "table" then
        local lookup = normalize(source)
        for key in pairs(base16) do
            local value = parse_hex(lookup[normalize_key(key)])
            if value then
                base16[key] = value
                found = true
            end
        end
    end
    return base16, found
end

-- Returns true when the JSON supplied at least one valid base16 color, false when only the fallback was used
function M.reload_colors()
    local base16, found = load_base16()
    vim.o.background = palette.is_light(base16.base00) and "light" or "dark"

    for name, spec in pairs(highlights.groups(base16)) do
        vim.api.nvim_set_hl(0, name, spec)
    end

    vim.g.colors_name = "base16-dynamic"
    vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
    vim.cmd.redrawstatus({ bang = true })
    return found
end

_G.reload_colors = M.reload_colors
vim.api.nvim_create_user_command("ReloadColors", M.reload_colors, { desc = "Reload base16 colors from the theme JSON" })

M.reload_colors()

return M
