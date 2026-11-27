vim.pack.add({ "https://github.com/rachartier/tiny-cmdline.nvim" }, { confirm = false })

-- Until Neovim 0.13 (neovim/neovim#36846) a floating search makes the plugin raise 'cmdheight' to 1, so / and ? stay native there
local float_search = vim.fn.has("nvim-0.13") == 1

require("tiny-cmdline").setup({ position = { y = "20%" }, native_types = float_search and {} or nil })
