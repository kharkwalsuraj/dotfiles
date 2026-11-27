vim.loader.enable()

-- Core
require("core.options")
require("core.autocmds")
require("core.keymaps")

-- Editor
require("editor.theme")
require("editor.statusline")
require("editor.messages")

-- Plugins (completion before lsp: lsp.lua enables servers with the capabilities completion.lua sets; mini before bufferline: mini.icons provides its icons)
require("plugins.completion")
require("plugins.lsp")
require("plugins.mini")
require("plugins.bufferline")
require("plugins.gitsigns")
require("plugins.cmdline")
require("plugins.oil")
require("plugins.fzf")
