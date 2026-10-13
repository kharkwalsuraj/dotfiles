return {
  { "stevearc/conform.nvim", opts = require "configs.conform", },

  { "neovim/nvim-lspconfig", config = function() require "configs.lspconfig" end },

  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "vim", "lua", "vimdoc", "html", "css" } }, },

  { "nvim-tree/nvim-tree.lua", opts = { view = { side = "right", width = 45 } } },

  { "NvChad/WallSync", lazy = false, main = "wallsync", opts = {} },
}
