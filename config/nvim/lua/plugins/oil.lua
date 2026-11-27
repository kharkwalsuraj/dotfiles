vim.pack.add({ "https://github.com/stevearc/oil.nvim" }, { confirm = false })

local oil = require("oil")

---@module "oil"
---@type oil.SetupOpts
local opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = { show_hidden = true },
    keymaps = {
        ["q"] = "actions.close",
        ["<C-p>"] = "actions.preview",
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-c>"] = false,
    },
}

oil.setup(opts)

local explorer_width = 0.35

local function resize_explorer(win) vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * explorer_width)) end

vim.keymap.set("n", "<leader>e", function()
    if vim.bo.filetype == "oil" then
        oil.close()
    else
        oil.open(nil, { preview = { vertical = true, split = "belowright" } }, function() resize_explorer(0) end)
    end
end, { desc = "Toggle file explorer" })

vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("UserOil", { clear = true }),
    callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "oil" then resize_explorer(win) end
        end
    end,
})
