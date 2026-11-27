-- Builds every highlight group from a base16 palette
local palette = require("editor.theme.palette")
local plugins = require("editor.theme.plugins")

local M = {}

---@param b Base16
---@return table<string, vim.api.keyset.highlight>
function M.groups(b)
    local bg = b.base00
    local float = b.base01
    local sel = b.base02
    local muted = b.base03
    local dim = b.base04
    local fg = b.base05
    local bright_fg = b.base06

    local function tint(color, alpha) return palette.blend(color, bg, alpha or 0.14) end

    local hl = {
        -- UI & Editor
        Normal = { fg = fg, bg = bg },
        NormalNC = { link = "Normal" },
        NormalFloat = { fg = fg, bg = float },
        FloatBorder = { fg = muted, bg = float },
        FloatTitle = { fg = b.base0D, bg = float, bold = true },
        FloatFooter = { fg = dim, bg = float },
        Cursor = { fg = bg, bg = b.base0D },
        lCursor = { link = "Cursor" },
        CursorIM = { link = "Cursor" },
        TermCursor = { reverse = true },
        CursorLine = { bg = float },
        CursorColumn = { link = "CursorLine" },
        ColorColumn = { bg = float },
        CursorLineNr = { fg = b.base0D, bold = true },
        LineNr = { fg = muted },
        LineNrAbove = { link = "LineNr" },
        LineNrBelow = { link = "LineNr" },
        SignColumn = { fg = dim, bg = bg },
        FoldColumn = { fg = muted, bg = bg },
        Folded = { fg = dim, bg = float },
        Visual = { bg = sel },
        VisualNOS = { link = "Visual" },
        MatchParen = { fg = b.base0A, bg = sel, bold = true },
        Search = { fg = bg, bg = b.base0A },
        CurSearch = { fg = bg, bg = b.base09, bold = true },
        IncSearch = { fg = bg, bg = b.base09 },
        Substitute = { fg = bg, bg = b.base08 },
        Pmenu = { fg = fg, bg = float },
        PmenuSel = { fg = bright_fg, bg = sel, bold = true },
        PmenuKind = { fg = dim, bg = float },
        PmenuKindSel = { fg = bright_fg, bg = sel },
        PmenuExtra = { fg = muted, bg = float },
        PmenuExtraSel = { fg = dim, bg = sel },
        PmenuMatch = { fg = b.base0D, bg = float, bold = true },
        PmenuMatchSel = { fg = b.base0D, bg = sel, bold = true },
        PmenuSbar = { bg = sel },
        PmenuThumb = { bg = muted },
        WildMenu = { link = "PmenuSel" },
        WinSeparator = { fg = sel },
        VertSplit = { link = "WinSeparator" },
        WinBar = { fg = dim, bg = bg },
        WinBarNC = { fg = muted, bg = bg },
        StatusLine = { fg = dim, bg = bg },
        StatusLineNC = { fg = muted, bg = bg },
        StatusLineTerm = { link = "StatusLine" },
        TabLine = { fg = dim, bg = float },
        TabLineFill = { bg = float },
        TabLineSel = { fg = bright_fg, bg = sel, bold = true },
        Title = { fg = b.base0D, bold = true },
        Directory = { fg = b.base0D },
        Question = { fg = b.base0B },
        MoreMsg = { fg = b.base0B },
        ModeMsg = { fg = fg, bold = true },
        ErrorMsg = { fg = b.base08 },
        WarningMsg = { fg = b.base0A },
        MsgArea = { fg = fg },
        MsgSeparator = { fg = sel, bg = float },
        NonText = { fg = sel },
        EndOfBuffer = { fg = bg },
        Whitespace = { fg = sel },
        SpecialKey = { fg = sel },
        Conceal = { fg = dim },
        Underlined = { fg = b.base0C, underline = true },
        Todo = { fg = bg, bg = b.base0A, bold = true },
        QuickFixLine = { bg = sel, bold = true },
        qfLineNr = { fg = muted },
        qfFileName = { fg = b.base0D },
        SpellBad = { sp = b.base08, undercurl = true },
        SpellCap = { sp = b.base0A, undercurl = true },
        SpellRare = { sp = b.base0E, undercurl = true },
        SpellLocal = { sp = b.base0C, undercurl = true },
        DiffAdd = { bg = tint(b.base0B) },
        DiffChange = { bg = tint(b.base0D) },
        DiffDelete = { fg = b.base08, bg = tint(b.base08) },
        DiffText = { bg = tint(b.base0D, 0.3), bold = true },
        Added = { fg = b.base0B },
        Changed = { fg = b.base0D },
        Removed = { fg = b.base08 },

        -- Syntax & Treesitter
        Comment = { fg = muted, italic = true },
        Constant = { fg = b.base09 },
        String = { fg = b.base0B },
        Character = { fg = b.base0B },
        Number = { fg = b.base09 },
        Boolean = { fg = b.base09 },
        Float = { fg = b.base09 },
        Identifier = { fg = b.base08 },
        Function = { fg = b.base0D },
        Statement = { fg = b.base0E },
        Conditional = { fg = b.base0E },
        Repeat = { fg = b.base0E },
        Label = { fg = b.base0D },
        Keyword = { fg = b.base0E },
        Exception = { fg = b.base0E },
        Operator = { fg = b.base0C },
        PreProc = { fg = b.base0E },
        Include = { fg = b.base0E },
        Define = { fg = b.base0E },
        Macro = { fg = b.base0E },
        PreCondit = { fg = b.base0E },
        Type = { fg = b.base0A },
        StorageClass = { fg = b.base0A },
        Structure = { fg = b.base0A },
        Typedef = { fg = b.base0A },
        Special = { fg = b.base0C },
        SpecialChar = { fg = b.base0C },
        Tag = { fg = b.base0A },
        Delimiter = { fg = b.base0F },
        SpecialComment = { fg = dim, italic = true },
        Debug = { fg = b.base08 },
        Error = { fg = b.base08 },
        ["@variable"] = { fg = fg },
        ["@variable.builtin"] = { fg = b.base08 },
        ["@variable.parameter"] = { fg = b.base08 },
        ["@variable.member"] = { fg = b.base0D },
        ["@property"] = { fg = b.base0D },
        ["@constant"] = { fg = b.base09 },
        ["@constant.builtin"] = { fg = b.base09 },
        ["@module"] = { fg = b.base0A },
        ["@label"] = { fg = b.base0D },
        ["@string.escape"] = { fg = b.base0C },
        ["@string.regexp"] = { fg = b.base0B },
        ["@string.special"] = { fg = b.base0C },
        ["@function.builtin"] = { fg = b.base0D },
        ["@constructor"] = { fg = b.base0C },
        ["@keyword.return"] = { fg = b.base0E, bold = true },
        ["@type.builtin"] = { fg = b.base0A },
        ["@attribute"] = { fg = b.base09 },
        ["@tag"] = { fg = b.base0A },
        ["@tag.attribute"] = { fg = b.base0C },
        ["@tag.delimiter"] = { fg = dim },
        ["@punctuation.delimiter"] = { fg = dim },
        ["@punctuation.bracket"] = { fg = dim },
        ["@markup.heading"] = { fg = b.base0D, bold = true },
        ["@markup.strong"] = { bold = true },
        ["@markup.italic"] = { italic = true },
        ["@markup.strikethrough"] = { strikethrough = true },
        ["@markup.link.url"] = { fg = b.base0D, underline = true },
        ["@markup.link.label"] = { fg = b.base0C },
        ["@markup.raw"] = { fg = b.base0B },
        ["@markup.list"] = { fg = b.base0E },
        ["@markup.quote"] = { fg = dim, italic = true },

        -- Statusline groups
        StlText = { fg = dim, bg = bg },
        StlMuted = { fg = muted, bg = bg },
        StlModified = { fg = b.base0A, bg = bg, bold = true },
        StlGit = { fg = b.base0E, bg = bg },
        StlAdd = { fg = b.base0B, bg = bg },
        StlChange = { fg = b.base0D, bg = bg },
        StlDelete = { fg = b.base08, bg = bg },
        StlError = { fg = b.base08, bg = bg },
        StlWarn = { fg = b.base0A, bg = bg },
        StlInfo = { fg = b.base0D, bg = bg },
        StlHint = { fg = b.base0C, bg = bg },
        StlLsp = { fg = b.base0D, bg = bg },
        StlCwd = { fg = bg, bg = b.base08, bold = true },
        StlCwdSep = { fg = b.base08, bg = bg },
        StlRecord = { fg = bg, bg = b.base08, bold = true },

        -- LSP
        LspReferenceText = { bg = sel },
        LspReferenceRead = { bg = sel },
        LspReferenceWrite = { bg = sel, underline = true },
        LspInlayHint = { fg = muted, bg = tint(muted, 0.12), italic = true },
        LspSignatureActiveParameter = { fg = b.base0D, bold = true, underline = true },
        LspCodeLens = { fg = muted },
    }

    local modes = {
        Normal = { bg, b.base0D },
        Visual = { bg, b.base0E },
        Insert = { bg, b.base0B },
        Replace = { bg, b.base08 },
        Command = { bg, b.base0A },
        Terminal = { bg, b.base0C },
    }
    for mode, colors in pairs(modes) do
        hl["StlMode" .. mode] = { fg = colors[1], bg = colors[2], bold = true }
        hl["StlMode" .. mode .. "Sep"] = { fg = colors[2], bg = bg }
    end
    hl.StlPos, hl.StlPosSep = { link = "StlModeNormal" }, { link = "StlModeNormalSep" }

    for name, color in pairs({ Error = b.base08, Warn = b.base0A, Info = b.base0D, Hint = b.base0C, Ok = b.base0B }) do
        hl["Diagnostic" .. name] = { fg = color }
        hl["DiagnosticVirtualText" .. name] = { fg = color, bg = tint(color, 0.1) }
        hl["DiagnosticFloating" .. name] = { fg = color }
        hl["DiagnosticSign" .. name] = { fg = color }
        hl["DiagnosticUnderline" .. name] = { sp = color, undercurl = true }
    end

    local context = { bg = bg, float = float, sel = sel, muted = muted, dim = dim, fg = fg, bright_fg = bright_fg, tint = tint }
    return vim.tbl_extend("error", hl, plugins(b, context))
end

return M
