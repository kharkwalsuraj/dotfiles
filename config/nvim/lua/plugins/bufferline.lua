vim.pack.add({ { src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("*") } }, { confirm = false })

require("bufferline").setup()
