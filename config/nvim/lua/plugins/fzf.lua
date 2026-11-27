vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, { confirm = false })

local fzf = require("fzf-lua")
local map = vim.keymap.set

local function toggle_smart_case(selected, opts) return fzf.actions.toggle_flag(selected, vim.tbl_extend("force", opts, { toggle_flag = "--smart-case" })) end

local function smart_case_header(opts)
    local flag = opts.toggle_smart_case_flag or "--smart-case"
    return opts.cmd and opts.cmd:match(fzf.utils.lua_regex_escape(flag)) and "Disable smart case" or "Enable smart case"
end

---@module "fzf-lua"
---@type fzf-lua.Config
local opts = {
    -- Selection, prompt, pointer etc. follow the Neovim highlight groups (editor/theme), so they update with the theme
    fzf_colors = {
        ["fg"] = { "fg", "FzfLuaNormal" },
        ["bg"] = { "bg", "FzfLuaNormal" },
        ["hl"] = { "fg", "Function" },
        ["fg+"] = { "fg", "Normal" },
        ["bg+"] = { "bg", "Visual" },
        ["hl+"] = { "fg", "Function" },
        ["info"] = { "fg", "Special" },
        ["prompt"] = { "fg", "Function" },
        ["pointer"] = { "fg", "Function" },
        ["marker"] = { "fg", "String" },
        ["spinner"] = { "fg", "Special" },
        ["header"] = { "fg", "Comment" },
        ["border"] = { "fg", "FzfLuaBorder" },
        ["gutter"] = { "bg", "FzfLuaNormal" },
    },
    keymap = { builtin = { ["<C-f>"] = "preview-page-down", ["<C-b>"] = "preview-page-up" } },
    grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --glob=!.git -e",
        actions = { ["ctrl-a"] = { fn = toggle_smart_case, desc = "toggle-flags", header = smart_case_header } },
    },
}

fzf.setup(opts)

map("n", "<leader><leader>", fzf.buffers, { desc = "[ ] Search buffers" })
map("n", "<leader>.", fzf.oldfiles, { desc = "[.] Search oldfiles (dot repeat)" })
map("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
map("n", "<leader>/", fzf.blines, { desc = "[/] Search words in the buffer" })
map("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by Live rip[G]rep (current directory)" })
map("n", "<leader>sj", fzf.jumps, { desc = "[S]earch [J]umplist" })
map("n", "<leader>st", fzf.tabs, { desc = "[S]earch [T]abs" })
map("n", "<leader>sh", fzf.command_history, { desc = "[S]earch Command [H]istory" })
map("n", "<leader>sc", fzf.colorschemes, { desc = "[S]earch [C]olorschemes" })
map("n", "<leader>ss", fzf.builtin, { desc = "[S]earch [S]earch (builtin)" })
map("n", "<leader>sr", fzf.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>gc", fzf.git_commits, { desc = "Search [G]it [C]ommits" })
map("n", "<leader>gs", fzf.git_status, { desc = "Search [G]it [S]tatus" })

map("n", "<leader>d-", function()
    local dirs = {}
    for dir in vim.fs.parents(vim.uv.cwd() or vim.api.nvim_buf_get_name(0)) do
        dirs[#dirs + 1] = dir
    end
    fzf.fzf_exec(dirs, {
        prompt = "Parent Directories> ",
        actions = {
            default = function(selected) fzf.files({ cwd = selected[1] }) end,
        },
    })
end, { desc = "Select & Search Parent([-]) [D]irectories" })

map("n", "<leader>di", function()
    vim.ui.input({ prompt = "Enter a directory: ", completion = "dir" }, function(input)
        if not input then return end
        local dir = vim.fs.normalize(input)
        local stat = vim.uv.fs_stat(dir)
        if stat and stat.type == "directory" then
            fzf.files({ cwd = dir })
        else
            vim.notify("Invalid directory!", vim.log.levels.WARN)
        end
    end)
end, { desc = "Search the [D]irectory of your [I]nput" })

map("n", "<leader>dc", function()
    fzf.fzf_exec("fd --hidden --type d --exclude .git", {
        prompt = "Directories> ",
        actions = {
            default = function(selected)
                if selected[1] then vim.api.nvim_set_current_dir(selected[1]) end
            end,
        },
    })
end, { desc = "Search and [C]hange CW[D]" })

fzf.register_ui_select()
