-- Highlight groups for plugins; the context comes from editor.theme.highlights
---@class ThemeContext
---@field bg string
---@field float string
---@field sel string
---@field muted string
---@field dim string
---@field fg string
---@field bright_fg string
---@field tint fun(color: string, alpha?: number): string

---@param b Base16
---@param c ThemeContext
---@return table<string, vim.api.keyset.highlight>
return function(b, c)
    local bg, float, sel, muted, dim, fg, bright_fg, tint = c.bg, c.float, c.sel, c.muted, c.dim, c.fg, c.bright_fg, c.tint

    local hl = {
        -- gitsigns.nvim
        GitSignsAdd = { fg = b.base0B },
        GitSignsChange = { fg = b.base0D },
        GitSignsDelete = { fg = b.base08 },
        GitSignsAddLn = { bg = tint(b.base0B, 0.12) },
        GitSignsChangeLn = { bg = tint(b.base0D, 0.12) },
        GitSignsDeleteLn = { bg = tint(b.base08, 0.12) },
        GitSignsAddInline = { bg = tint(b.base0B, 0.3) },
        GitSignsChangeInline = { bg = tint(b.base0D, 0.3) },
        GitSignsDeleteInline = { bg = tint(b.base08, 0.3) },
        GitSignsAddPreview = { link = "DiffAdd" },
        GitSignsDeletePreview = { link = "DiffDelete" },
        GitSignsCurrentLineBlame = { fg = muted, italic = true },
        GitSignsVirtLnum = { fg = muted },

        -- oil.nvim
        OilDir = { fg = b.base0D, bold = true },
        OilDirIcon = { fg = b.base0D },
        OilFile = { fg = fg },
        OilLink = { fg = b.base0C },
        OilLinkTarget = { fg = dim },
        OilSocket = { fg = b.base0E },
        OilOrphanLink = { fg = b.base08 },
        OilOrphanLinkTarget = { fg = b.base08, italic = true },
        OilEmpty = { fg = muted },
        OilHidden = { fg = muted },
        OilDirHidden = { fg = muted },
        OilFileHidden = { fg = muted },
        OilLinkHidden = { fg = muted },
        OilCreate = { fg = b.base0B },
        OilDelete = { fg = b.base08 },
        OilMove = { fg = b.base0A },
        OilCopy = { fg = b.base0C },
        OilChange = { fg = b.base0D },
        OilRestore = { fg = b.base0B },
        OilPurge = { fg = b.base08 },
        OilTrash = { fg = b.base0A },
        OilTrashSourcePath = { fg = muted },

        -- mini.clue
        MiniClueBorder = { link = "FloatBorder" },
        MiniClueTitle = { fg = b.base0D, bg = float, bold = true },
        MiniClueSeparator = { fg = sel, bg = float },
        MiniClueDescGroup = { fg = b.base0E, bg = float, bold = true },
        MiniClueDescSingle = { fg = fg, bg = float },
        MiniClueNextKey = { fg = b.base0D, bg = float, bold = true },
        MiniClueNextKeyWithPostkeys = { fg = b.base0E, bg = float, bold = true },

        -- mini.icons, mini.surround
        MiniIconsAzure = { fg = b.base0D },
        MiniIconsBlue = { fg = b.base0D },
        MiniIconsCyan = { fg = b.base0C },
        MiniIconsGreen = { fg = b.base0B },
        MiniIconsGrey = { fg = muted },
        MiniIconsOrange = { fg = b.base09 },
        MiniIconsPurple = { fg = b.base0E },
        MiniIconsRed = { fg = b.base08 },
        MiniIconsYellow = { fg = b.base0A },
        MiniSurround = { fg = bg, bg = b.base0A },

        -- tiny-cmdline.nvim
        TinyCmdlineNormal = { fg = fg, bg = float },
        TinyCmdlineBorder = { fg = b.base0D, bg = float },
        TinyCmdlineTitle = { fg = b.base0D, bg = float, bold = true },

        -- blink.cmp
        BlinkCmpMenu = { link = "Pmenu" },
        BlinkCmpMenuBorder = { link = "FloatBorder" },
        BlinkCmpMenuSelection = { link = "PmenuSel" },
        BlinkCmpScrollBarThumb = { link = "PmenuThumb" },
        BlinkCmpScrollBarGutter = { link = "PmenuSbar" },
        BlinkCmpLabel = { fg = fg },
        BlinkCmpLabelDeprecated = { fg = muted, strikethrough = true },
        BlinkCmpLabelMatch = { fg = b.base0D, bold = true },
        BlinkCmpLabelDetail = { fg = muted },
        BlinkCmpLabelDescription = { fg = muted },
        BlinkCmpKind = { fg = b.base0E },
        BlinkCmpSource = { fg = muted },
        BlinkCmpGhostText = { fg = muted, italic = true },
        BlinkCmpDoc = { link = "NormalFloat" },
        BlinkCmpDocBorder = { link = "FloatBorder" },
        BlinkCmpDocSeparator = { fg = sel, bg = float },
        BlinkCmpDocCursorLine = { link = "Visual" },
        BlinkCmpSignatureHelp = { link = "NormalFloat" },
        BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
        BlinkCmpSignatureHelpActiveParameter = { link = "LspSignatureActiveParameter" },

        -- fzf-lua
        FzfLuaNormal = { fg = fg, bg = float },
        FzfLuaBorder = { fg = muted, bg = float },
        FzfLuaTitle = { fg = bg, bg = b.base0D, bold = true },
        FzfLuaTitleFlags = { fg = bright_fg, bg = sel },
        FzfLuaBackdrop = { bg = bg },
        FzfLuaPreviewNormal = { fg = fg, bg = bg },
        FzfLuaPreviewBorder = { fg = muted, bg = bg },
        FzfLuaPreviewTitle = { fg = bg, bg = b.base0E, bold = true },
        FzfLuaCursor = { link = "Cursor" },
        FzfLuaCursorLine = { bg = sel },
        FzfLuaCursorLineNr = { fg = b.base0D, bold = true },
        FzfLuaSearch = { link = "Search" },
        FzfLuaHelpNormal = { fg = fg, bg = float },
        FzfLuaHelpBorder = { fg = muted, bg = float },
        FzfLuaHeaderBind = { fg = b.base0A },
        FzfLuaHeaderText = { fg = b.base08 },
        FzfLuaPathColNr = { fg = b.base0C },
        FzfLuaPathLineNr = { fg = b.base0A },
        FzfLuaBufName = { fg = b.base0E },
        FzfLuaBufNr = { fg = b.base0A },
        FzfLuaBufId = { fg = muted },
        FzfLuaBufLineNr = { fg = muted },
        FzfLuaBufFlagCur = { fg = b.base08 },
        FzfLuaBufFlagAlt = { fg = b.base0D },
        FzfLuaTabTitle = { fg = b.base0D, bold = true },
        FzfLuaTabMarker = { fg = b.base0A },
        FzfLuaLivePrompt = { fg = b.base08 },
        FzfLuaLiveSym = { fg = b.base08 },
        FzfLuaDirIcon = { fg = b.base0D },
        FzfLuaDirPart = { fg = dim },
        FzfLuaFilePart = { fg = fg },
        FzfLuaCmdEx = { fg = b.base0D },
        FzfLuaCmdBuf = { fg = b.base0E },
        FzfLuaCmdGlobal = { fg = b.base0A },
        FzfLuaScrollBorderEmpty = { fg = sel },
        FzfLuaScrollBorderFull = { fg = muted },
        FzfLuaScrollFloatEmpty = { bg = sel },
        FzfLuaScrollFloatFull = { bg = muted },
        FzfLuaFzfNormal = { fg = fg },
        FzfLuaFzfCursorLine = { bg = sel },
        FzfLuaFzfMatch = { fg = b.base0D, bold = true },
        FzfLuaFzfBorder = { fg = muted },
        FzfLuaFzfScrollbar = { fg = muted },
        FzfLuaFzfSeparator = { fg = sel },
        FzfLuaFzfGutter = { bg = float },
        FzfLuaFzfHeader = { fg = b.base08 },
        FzfLuaFzfInfo = { fg = dim },
        FzfLuaFzfPointer = { fg = b.base0D },
        FzfLuaFzfMarker = { fg = b.base0E },
        FzfLuaFzfSpinner = { fg = b.base0C },
        FzfLuaFzfPrompt = { fg = b.base0D },
        FzfLuaFzfQuery = { fg = fg },
    }

    local kinds = {
        Function = b.base0D,
        Method = b.base0D,
        Constructor = b.base0C,
        Field = b.base0D,
        Property = b.base0D,
        Variable = fg,
        Class = b.base0A,
        Interface = b.base0A,
        Struct = b.base0A,
        Enum = b.base0A,
        EnumMember = b.base0A,
        Constant = b.base09,
        Module = b.base0E,
        Keyword = b.base0E,
        Snippet = b.base0B,
        Text = dim,
        Operator = b.base0C,
        Unit = b.base09,
        Value = b.base09,
        Color = b.base0E,
        File = b.base0D,
        Folder = b.base0D,
        Reference = b.base0C,
        Event = b.base08,
        TypeParameter = b.base0A,
        Copilot = b.base0B,
    }
    for kind, color in pairs(kinds) do
        hl["BlinkCmpKind" .. kind] = { fg = color }
    end

    return hl
end
