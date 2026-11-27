vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { confirm = false })

local severity = vim.diagnostic.severity

vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = { spacing = 2, prefix = "●" },
    float = { source = true },
    jump = { float = true },
    signs = { text = { [severity.ERROR] = "\u{f015a}", [severity.WARN] = "\u{f002a}", [severity.INFO] = "\u{f02fd}", [severity.HINT] = "\u{f0336}" } },
})

vim.keymap.set("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle diagnostics" })

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(ev)
        local function map(lhs, rhs, desc, mode) vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, desc = desc }) end

        ---@type vim.lsp.buf.code_action.Opts
        local organize = { context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true }

        map("gd", vim.lsp.buf.definition, "Definition")
        map("gD", vim.lsp.buf.declaration, "Declaration")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
        map("<leader>cr", vim.lsp.buf.rename, "Rename")
        map("<leader>co", function() vim.lsp.buf.code_action(organize) end, "Organize imports")
        map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format", { "n", "x" })
        map("<leader>df", vim.diagnostic.open_float, "Diagnostic float")
        map("<leader>dl", vim.diagnostic.setloclist, "Diagnostics to loclist")
        map("<leader>ui", function()
            local opts = { bufnr = ev.buf }
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(opts), opts)
        end, "Toggle inlay hints")
    end,
})

-- Server settings live in after/lsp/
vim.lsp.enable({ "lua_ls", "basedpyright", "qmlls" })
