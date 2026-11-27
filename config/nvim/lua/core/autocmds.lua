local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", { group = group, callback = function() vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 }) end })
autocmd("VimResized", { group = group, command = "tabdo wincmd =" })

-- Pick up files changed outside Neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = group,
    callback = function()
        if vim.o.buftype ~= "nofile" then vim.cmd.checktime() end
    end,
})

-- Create missing parent directories on write
autocmd("BufWritePre", {
    group = group,
    callback = function(ev)
        if ev.match:match("^%w%w+:[\\/][\\/]") then return end
        vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(ev.match) or ev.match, ":p:h"), "p")
    end,
})

autocmd("BufWritePre", {
    group = group,
    pattern = { "*.lua", "*.py", "*.js", "*.ts", "*.rs", "*.go" },
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Reopen a file at the last cursor position
autocmd("BufReadPost", {
    group = group,
    callback = function(ev)
        local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
    end,
})

autocmd("FileType", { group = group, pattern = { "text", "markdown", "gitcommit" }, callback = function() vim.opt_local.spell = true end })

-- Filetype plugins add "o" back, so it has to be removed per buffer
autocmd("FileType", { group = group, callback = function() vim.opt_local.formatoptions:remove("o") end })

-- Close read-only windows with q
autocmd("FileType", {
    group = group,
    pattern = { "help", "qf", "man", "checkhealth" },
    callback = function(ev) vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, desc = "Close window" }) end,
})

-- Delete empty unnamed buffers when they get hidden, like the one left after opening a file from the start screen
autocmd("BufHidden", {
    group = group,
    callback = function(ev)
        local buf = ev.buf
        if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].buftype ~= "" or vim.bo[buf].modified then return end
        if vim.api.nvim_buf_line_count(buf) > 1 or vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] ~= "" then return end

        vim.schedule(function() pcall(vim.api.nvim_buf_delete, buf, {}) end)
    end,
})
