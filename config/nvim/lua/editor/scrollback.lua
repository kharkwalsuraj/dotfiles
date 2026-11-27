-- Neovim as kitty's scrollback pager; required from kitty.conf (scrollback_pager), not from init.lua
-- Reference: https://gist.github.com/galaxia4Eva/9e91c4f275554b4bd844b6feece16b3d
---@param input_line integer
---@param cursor_line integer
---@param cursor_column integer
return function(input_line, cursor_line, cursor_column)
    vim.opt.showmode = false
    vim.opt.laststatus = 0
    vim.opt.ruler = false
    vim.o.clipboard = "unnamedplus"
    vim.opt.scrollback = input_line + cursor_line

    local term_buf = vim.api.nvim_create_buf(true, false)
    local term_io = vim.api.nvim_open_term(term_buf, {})
    local group = vim.api.nvim_create_augroup("UserKittyScrollback", {})

    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = term_buf })

    local function set_cursor()
        local line = math.min(cursor_line, vim.api.nvim_buf_line_count(term_buf))
        vim.api.nvim_feedkeys(input_line .. "ggzt", "n", true)
        vim.api.nvim_feedkeys((line - 1) .. "j", "n", true)
        vim.api.nvim_feedkeys("0", "n", true)
        vim.api.nvim_feedkeys((cursor_column - 1) .. "l", "n", true)
    end

    vim.api.nvim_create_autocmd("ModeChanged", {
        group = group,
        buffer = term_buf,
        callback = function()
            if vim.fn.mode() == "t" then
                vim.cmd.stopinsert()
                vim.schedule(set_cursor)
            end
        end,
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        once = true,
        callback = function(args)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(args.buf, 0, -2, false)) do
                vim.api.nvim_chan_send(term_io, line)
                vim.api.nvim_chan_send(term_io, "\r\n")
            end
            for _, line in ipairs(vim.api.nvim_buf_get_lines(args.buf, -2, -1, false)) do
                vim.api.nvim_chan_send(term_io, line)
            end

            vim.api.nvim_win_set_buf(vim.fn.win_getid(), term_buf)
            vim.api.nvim_buf_delete(args.buf, { force = true })
            vim.schedule(set_cursor)
        end,
    })
end
