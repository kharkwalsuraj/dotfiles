require "nvchad.mappings"

local map = vim.keymap.set
local del = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

map("n", "<A-j>", "5j", { desc = "Move down" })
map("n", "<A-k>", "5k", { desc = "Move up" })

map("n", "<A-k>", "<cmd>move .-2<CR>==", { desc = "Move line up" })
map("n", "<A-j>", "<cmd>move .+1<CR>==", { desc = "Move line down" })

-- Goated keymap
map("n", "<leader>ch", "<cmd>edit ~/.local/share/nvim/lazy/NvChad/lua/nvchad/mappings.lua<CR>",
{ desc = "Open NvChad default mappings", })

-- NvimTree
-- Leader + e: Toggle NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree toggle window" })

-- Remove NvChad's default Ctrl + n NvimTree mapping
del("n", "<C-n>")
