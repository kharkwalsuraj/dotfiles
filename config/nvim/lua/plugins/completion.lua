vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
    "https://github.com/rafamadriz/friendly-snippets",
}, { confirm = false })

local blink = require("blink.cmp")

---@module "blink.cmp"
---@type blink.cmp.Config
local opts = {
    keymap = { preset = "enter", ["<C-y>"] = { "select_and_accept" } },
    completion = {
        menu = { border = "none", draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    cmdline = {
        keymap = { preset = "cmdline", ["<Right>"] = false, ["<Left>"] = false },
        completion = {
            list = { selection = { preselect = false } },
            menu = { auto_show = function() return vim.fn.getcmdtype() == ":" end },
            ghost_text = { enabled = true },
        },
    },
}

blink.setup(opts)

-- Servers also get blink's capabilities and file rename support
---@type lsp.ClientCapabilities
local rename = { workspace = { fileOperations = { didRename = true, willRename = true } } }
vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities(rename) })
