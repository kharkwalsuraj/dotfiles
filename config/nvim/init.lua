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
