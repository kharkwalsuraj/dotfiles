-- Message routing through ui2 (experimental, 0.12+)
local ui2 = require("vim._core.ui2")

ui2.enable({
    enable = true,
    msg = {
        target = "msg",
        targets = {
            list_cmd = "pager",
            shell_cmd = "pager",
            shell_out = "pager",
            shell_err = "pager",
            verbose = "pager",
            search_cmd = "cmd",
            search_count = "cmd",
            wildlist = "cmd",
            confirm = "cmd",
        },
        cmd = { height = 0.5 },
        dialog = { height = 0.5 },
        msg = { height = 0.3, timeout = 1000 },
        pager = { height = 0.7 },
    },
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserMessages", { clear = true }),
    pattern = "msg",
    callback = function()
        local win = ui2.wins.msg
        if win and vim.api.nvim_win_is_valid(win) then vim.wo[win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder" end
    end,
})

local ok, messages = pcall(require, "vim._core.ui2.messages")
if ok and type(messages) == "table" then
    local set_pos = messages.set_pos
    if type(set_pos) == "function" then
        messages.set_pos = function(target)
            set_pos(target)
            local win = ui2.wins.msg
            if (target == "msg" or target == nil) and win and vim.api.nvim_win_is_valid(win) then
                pcall(vim.api.nvim_win_set_config, win, { relative = "editor", anchor = "NE", row = 1, col = vim.o.columns })
            end
        end
    end
end

vim.keymap.set("n", "<leader>mm", "<cmd>messages<cr>", { desc = "Message history" })
