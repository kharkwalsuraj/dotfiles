vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" }, { confirm = false })

local gs = require("gitsigns")

---@type Gitsigns.Config
local opts = {
    on_attach = function(buf)
        local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc }) end

        local function nav(direction, key)
            return function()
                if vim.wo.diff then
                    vim.cmd.normal({ key, bang = true })
                else
                    gs.nav_hunk(direction)
                end
            end
        end

        local function range(action)
            return function() action({ vim.fn.line("."), vim.fn.line("v") }) end
        end

        map("n", "]c", nav("next", "]c"), "Next hunk")
        map("n", "[c", nav("prev", "[c"), "Prev hunk")

        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", range(gs.stage_hunk), "Stage hunk")
        map("v", "<leader>hr", range(gs.reset_hunk), "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hi", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")
        map("n", "<leader>hq", gs.setqflist, "Hunks to quickfix")
        map("n", "<leader>hQ", function() gs.setqflist("all") end, "All hunks to quickfix")

        map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>uw", gs.toggle_word_diff, "Toggle word diff")

        map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
    end,
}

gs.setup(opts)
