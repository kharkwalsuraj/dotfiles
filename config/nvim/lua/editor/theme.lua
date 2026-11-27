-- Applies highlight groups from editor/theme/colors.lua, which shell/scripts/apply-nvim.py overwrites and then reloads
local palette = require("editor.theme.palette")
local highlights = require("editor.theme.highlights")

local M = {}

local function load_base16()
    package.loaded["editor.theme.colors"] = nil
    local ok, colors = pcall(require, "editor.theme.colors")
    return ok and type(colors) == "table" and colors or {}
end

function M.reload()
    local base16 = load_base16()
    local background = palette.is_light(base16.base00) and "light" or "dark"
    if vim.o.background ~= background then vim.o.background = background end

    for name, spec in pairs(highlights.groups(base16)) do
        vim.api.nvim_set_hl(0, name, spec)
    end

    vim.g.colors_name = "base16-dynamic"
    vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
    vim.cmd.redrawstatus({ bang = true })
end

vim.api.nvim_create_user_command("ReloadColors", M.reload, { desc = "Reload base16 colors from editor/theme/colors.lua" })

M.reload()

return M
