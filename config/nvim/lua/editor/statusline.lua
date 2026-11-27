-- Native statusline: mode pill, git, file, then diagnostics, LSP, working directory and position on the right
local M = {}

-- Mode -> { label, highlight suffix }
---@type table<string, string[]>
local modes = {
    n = { "NORMAL", "Normal" }, no = { "OP", "Normal" }, nt = { "NORMAL", "Normal" },
    v = { "VISUAL", "Visual" }, V = { "V-LINE", "Visual" }, ["\22"] = { "V-BLOCK", "Visual" },
    s = { "SELECT", "Visual" }, S = { "SELECT", "Visual" },
    i = { "INSERT", "Insert" }, ic = { "INSERT", "Insert" },
    R = { "REPLACE", "Replace" }, Rv = { "REPLACE", "Replace" },
    c = { "COMMAND", "Command" }, cv = { "COMMAND", "Command" }, ce = { "COMMAND", "Command" },
    r = { "PROMPT", "Command" }, rm = { "MORE", "Command" }, ["r?"] = { "CONFIRM", "Command" },
    ["!"] = { "SHELL", "Terminal" }, t = { "TERMINAL", "Terminal" },
}

local sym = {
    cap_left = "\u{e0b6}", cap_right = "\u{e0b4}", branch = "\u{e0a0}",
    lock = "\u{f023}", lsp = "\u{f085}", progress = "\u{f110}", folder = "\u{f07b}", position = "\u{f0c9}", nvim = "\u{e6ae}",
}

---@type { [1]: integer, [2]: string, [3]: string }[]
local severities = {
    { vim.diagnostic.severity.ERROR, "StlError", "\u{f057}" },
    { vim.diagnostic.severity.WARN, "StlWarn", "\u{f071}" },
    { vim.diagnostic.severity.INFO, "StlInfo", "\u{f05a}" },
    { vim.diagnostic.severity.HINT, "StlHint", "\u{f0eb}" },
}

---@type table<string, boolean>
local icon_groups = {}

local function escape(text) return (text:gsub("%%", "%%%%")) end

-- mini.icons groups only set a foreground, so copy it onto the statusline background
local function file_icon(name, buf)
    local ok, icons_mod = pcall(require, "mini.icons")
    if not ok then return "" end

    local icon, group
    if vim.bo[buf].buftype == "terminal" then
        icon, group = icons_mod.get("filetype", "terminal")
    elseif vim.bo[buf].filetype == "oil" then
        icon, group = icons_mod.get("directory", name)
    else
        icon, group = icons_mod.get("file", name)
    end

    local custom = "Stl" .. group
    if not icon_groups[custom] then
        local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
        local stl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
        vim.api.nvim_set_hl(0, custom, { fg = hl.fg, bg = stl.bg })
        icon_groups[custom] = true
    end
    return ("%%#%s#%s %%#StlText#"):format(custom, icon)
end

-- Labels hug the icon and are padded to the width of the longest one, so the right side never shifts when the mode changes
local mode_width = 0
for _, info in pairs(modes) do
    mode_width = math.max(mode_width, #info[1])
end

local function mode_pill()
    local mode = vim.api.nvim_get_mode().mode
    local info = modes[mode] or modes[mode:sub(1, 1)] or { mode:upper(), "Normal" }
    local group = "StlMode" .. info[2]
    return ("%%#%s# %s %s %%#%sSep#%s%%#StlText#"):format(group, sym.nvim, ("%-" .. mode_width .. "s"):format(info[1]), group, sym.cap_right)
end

local function git_section(buf)
    local branch = vim.b[buf].gitsigns_head
    if type(branch) ~= "string" or branch == "" then return "" end

    local out = ("%%#StlGit#%s %s"):format(sym.branch, escape(branch))
    local diff = vim.b[buf].gitsigns_status_dict or {}
    if (diff.added or 0) > 0 then out = out .. ("%%#StlAdd# +%d"):format(diff.added) end
    if (diff.changed or 0) > 0 then out = out .. ("%%#StlChange# ~%d"):format(diff.changed) end
    if (diff.removed or 0) > 0 then out = out .. ("%%#StlDelete# -%d"):format(diff.removed) end
    return out .. "%#StlText#  "
end

local function file_section(buf)
    local name
    if vim.bo[buf].filetype == "oil" then
        local ok, oil = pcall(require, "oil")
        name = ok and vim.fn.fnamemodify(oil.get_current_dir(buf) or "", ":~") or "oil"
    elseif vim.bo[buf].buftype == "terminal" then
        name = "terminal"
    else
        name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")
        if name == "" then name = "[No Name]" end
    end

    local out = file_icon(name, buf) .. "%<" .. escape(name)
    if vim.bo[buf].modified then out = out .. " %#StlModified#●%#StlText#" end
    if vim.bo[buf].readonly or not vim.bo[buf].modifiable then out = out .. (" %%#StlMuted#%s"):format(sym.lock) end
    return out
end

local function diagnostics_section(buf)
    local counts = vim.diagnostic.count(buf)
    local parts = {}
    for _, item in ipairs(severities) do
        local count = counts[item[1]]
        if count and count > 0 then parts[#parts + 1] = ("%%#%s#%s %d"):format(item[2], item[3], count) end
    end
    if #parts == 0 then return "" end
    return table.concat(parts, " ") .. "%#StlText#  "
end

local function lsp_section(buf)
    local out = ""

    local status = vim.lsp.status()
    if status ~= "" then out = ("%%#StlMuted#%s %s  "):format(sym.progress, escape(vim.fn.strcharpart(status, 0, 32))) end

    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
        names[#names + 1] = client.name
    end
    if #names > 0 then out = out .. ("%%#StlLsp#%s %s%%#StlText#  "):format(sym.lsp, escape(table.concat(names, ","))) end
    return out
end

local function recording_section()
    local reg = vim.fn.reg_recording()
    if reg == "" then return "" end
    return ("%%#StlRecord#\u{f044a} @%s%%#StlText#  "):format(reg)
end

-- NvChad-style boxes: an icon on a colored cap, followed by plain text
local function cwd_section()
    local name = vim.fn.fnamemodify(vim.uv.cwd() or vim.fn.getcwd(), ":t")
    return ("%%#StlCwdSep#%s%%#StlCwd# %s  %%#StlText# %s  "):format(sym.cap_left, sym.folder, escape(name ~= "" and name or "/"))
end

local function position_section() return ("%%#StlPosSep#%s%%#StlPos# %s  %%#StlText# %%P "):format(sym.cap_left, sym.position) end

function M.render()
    local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_win_get_buf(win)

    return table.concat({
        mode_pill(),
        " ",
        git_section(buf),
        file_section(buf),
        "%#StlText#%=",
        recording_section(),
        diagnostics_section(buf),
        lsp_section(buf),
        cwd_section(),
        position_section(),
    })
end

vim.o.statusline = "%!v:lua.require'editor.statusline'.render()"

local group = vim.api.nvim_create_augroup("UserStatusline", { clear = true })

vim.api.nvim_create_autocmd({ "LspProgress", "LspAttach", "LspDetach", "DiagnosticChanged", "RecordingEnter", "RecordingLeave" }, {
    group = group,
    callback = function() vim.cmd.redrawstatus() end,
})

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "GitSignsUpdate",
    callback = function() vim.cmd.redrawstatus() end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function() icon_groups = {} end,
})

return M
