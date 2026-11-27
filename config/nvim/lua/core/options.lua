local opt = vim.opt

-- Leader must be set before any mapping is created
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.cursorlineopt = "number"

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftround = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Window and UI
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.cmdheight = 0
opt.laststatus = 3
opt.showmode = false
opt.winborder = "rounded"
opt.title = true
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.winminwidth = 5
opt.virtualedit = "block"
opt.jumpoptions = "view"
opt.confirm = true
opt.shortmess:append("csCFW")

-- Invisible characters (trailing spaces are stripped on save)
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars:append({ eob = " ", diff = "╱" })

-- Popup menu
opt.pumheight = 10
opt.pumwidth = 20
opt.pumblend = 10
opt.completeopt = "menu,menuone,noselect"

-- Files and undo
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.undolevels = 10000

-- Timing
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 0

-- Behavior
opt.clipboard = "unnamedplus"
opt.mouse = ""
opt.iskeyword:append("-")
opt.path:append("**")
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Cursor shapes
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Folding (treesitter)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
