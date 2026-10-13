require "nvchad.mappings"

local map = vim.keymap.set
local del = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Goated keymap
map("n", "<leader>ch", "<cmd>edit ~/.local/share/nvim/lazy/NvChad/lua/nvchad/mappings.lua<CR>",
{ desc = "Open NvChad default mappings", })

-- Terminal
-- Leader + h: Toggle horizontal terminal
map({ "n", "t" }, "<leader>h", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- Alt + h: Open a new horizontal terminal
map("n", "<A-h>", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

-- Ctrl + n: Close the current terminal window from terminal mode
map("t", "<C-n>", "<C-\\><C-N><cmd>close!<CR>", { desc = "Terminal close window", })

-- Keep the standard terminal escape mapping
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal escape terminal mode" })

-- NvimTree
-- Leader + e: Toggle NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree toggle window" })

-- Remove NvChad's default Ctrl + n NvimTree mapping
del("n", "<C-n>")
