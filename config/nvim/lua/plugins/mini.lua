vim.pack.add({
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/nvim-mini/mini.pairs",
    "https://github.com/nvim-mini/mini.surround",
    "https://github.com/nvim-mini/mini.clue",
}, { confirm = false })

local icons = require("mini.icons")
icons.setup()
icons.mock_nvim_web_devicons()

require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = false } })
require("mini.surround").setup({
    mappings = { add = "gsa", delete = "gsd", find = "gsf", find_left = "gsF", highlight = "gsh", replace = "gsr", update_n_lines = "gsn" },
})

local clue = require("mini.clue")

clue.setup({
    triggers = {
        { mode = "n", keys = "<Leader>" }, { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "g" }, { mode = "x", keys = "g" },
        { mode = "n", keys = "z" }, { mode = "x", keys = "z" },
        { mode = "n", keys = "[" }, { mode = "n", keys = "]" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "'" }, { mode = "n", keys = "`" },
        { mode = "n", keys = '"' }, { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" }, { mode = "c", keys = "<C-r>" },
    },
    clues = {
        clue.gen_clues.builtin_completion(), clue.gen_clues.g(), clue.gen_clues.marks(),
        clue.gen_clues.registers(), clue.gen_clues.windows(), clue.gen_clues.z(),
        { mode = "n", keys = "<Leader>b", desc = "+buffer" },
        { mode = "n", keys = "<Leader>c", desc = "+code" }, { mode = "x", keys = "<Leader>c", desc = "+code" },
        { mode = "n", keys = "<Leader>d", desc = "+dirs & diagnostics" },
        { mode = "n", keys = "<Leader>g", desc = "+git" },
        { mode = "n", keys = "<Leader>h", desc = "+hunks" }, { mode = "x", keys = "<Leader>h", desc = "+hunks" },
        { mode = "n", keys = "<Leader>m", desc = "+messages" },
        { mode = "n", keys = "<Leader>s", desc = "+search" },
        { mode = "n", keys = "<Leader>u", desc = "+ui toggles" },
        { mode = "n", keys = "<Leader>x", desc = "+lists" },
        { mode = "n", keys = "gs", desc = "+surround" }, { mode = "x", keys = "gs", desc = "+surround" },
        { mode = "n", keys = "gr", desc = "+lsp" },
    },
    window = { delay = 300 },
})
