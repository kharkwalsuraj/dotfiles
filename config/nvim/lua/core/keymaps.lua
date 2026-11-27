-- Global keymaps only; plugin, LSP and feature keymaps live next to their code
local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>write<cr><Esc>", { desc = "Save" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Quit
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>quitall<cr>", { desc = "Quit all" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Grow height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Shrink height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Shrink width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Grow width" })

-- Buffers
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bb", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Editing
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("x", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Separate undo steps while typing
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")

-- Centered scrolling and search (n/N always go forward/backward, even after ?)
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "n", "'Nn'[v:searchforward] . 'zzzv'", { expr = true, desc = "Next match" })
map("n", "N", "'nN'[v:searchforward] . 'zzzv'", { expr = true, desc = "Previous match" })

-- Lists and diagnostics
local severity = vim.diagnostic.severity

local function toggle_list(is_open, open, close)
    return function() vim.cmd(is_open() and close or open) end
end

local function jump(count, level)
    return function() vim.diagnostic.jump({ count = count, severity = level }) end
end

local function quickfix_open() return vim.fn.getqflist({ winid = 0 }).winid ~= 0 end

local function loclist_open() return vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 end

map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix" })
map("n", "<leader>xq", toggle_list(quickfix_open, "copen", "cclose"), { desc = "Toggle quickfix" })
map("n", "<leader>xl", toggle_list(loclist_open, "lopen", "lclose"), { desc = "Toggle location list" })
map("n", "]e", jump(1, severity.ERROR), { desc = "Next error" })
map("n", "[e", jump(-1, severity.ERROR), { desc = "Previous error" })
map("n", "]w", jump(1, severity.WARN), { desc = "Next warning" })
map("n", "[w", jump(-1, severity.WARN), { desc = "Previous warning" })
