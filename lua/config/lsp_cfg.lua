local M = {}
-----------------------------------------------------------------------------------------
-- LSP 配置
------------------------------------------------------------------------------------------
local lspconfig = require("lspconfig")

-----------------------------------------------------------------------------------------
-- 切换头文件函数
------------------------------------------------------------------------------------------
local function switch_file_and_search()
    -- 获取当前文件名
    local current_file = vim.fn.expand("%:t:r") -- 文件名（不带路径和扩展名）
    local file_extension = vim.fn.expand("%:e") -- 扩展名
    local filename

    if file_extension == "c" or file_extension == "cpp" or file_extension == "cxx" then
        filename = current_file .. ".h"
    elseif file_extension == "h" or file_extension == "hpp" then
        filename = current_file .. ".c"
    else
        vim.notify("Not a C/C++ file", vim.log.levels.WARN)
        return
    end

    require("telescope.builtin").find_files({
        cwd = vim.g.workspace_dir.get(),
        default_text = filename,
    })
end

-----------------------------------------------------------------------------------------
-- capabilities 设置
------------------------------------------------------------------------------------------
local g_capabilities = require("cmp_nvim_lsp").default_capabilities()
g_capabilities.textDocument.completion.completionItem.snippetSupport = false

-----------------------------------------------------------------------------------------
-- clangd 配置
------------------------------------------------------------------------------------------
local function on_clangd_attach(client, bufnr)
    local telescope = require("telescope.builtin")
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = bufnr, desc = "Find definitions" })
    vim.keymap.set("n", "gi", telescope.lsp_implementations, { buffer = bufnr, desc = "Find implementations" })
    vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = bufnr, desc = "Find references" })
    vim.keymap.set("n", "gl", telescope.lsp_document_symbols, { buffer = bufnr, desc = "Document symbols" })
    vim.keymap.set("n", "ga", telescope.lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = "Workspace symbols" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>fx", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>hS", switch_file_and_search, opts)
    vim.keymap.set("n", "<leader>hs", ":ClangdSwitchSourceHeader<CR>", opts)
    vim.keymap.set("i", "<M-k>", vim.lsp.buf.signature_help, opts)
end

lspconfig.clangd.setup({
    cmd = {
        "clangd.exe",
        "--background-index=true",
        "--clang-tidy",
        "--compile-commands-dir=build",
        "--pch-storage=disk",
        "--completion-style=bundled",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "cxx", "h" },
    capabilities = g_capabilities,
    diagnostics = {
        update_in_insert = false,
        debounce = 300,
        severity_sort = true,
    },
    on_attach = on_clangd_attach,
})

-----------------------------------------------------------------------------------------
-- 动态切换 clangd
------------------------------------------------------------------------------------------
function M.switch_clangd(clangd_path, compiler_path)
    local new_config = {
        name = "clangd",
        cmd = {
            clangd_path,
            "--background-index=true",
            "--clang-tidy",
            "--compile-commands-dir=build",
            "--pch-storage=disk",
            "--completion-style=bundled",
            "--query-driver=" .. compiler_path,
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp", "cxx", "h" },
        root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".git"),
        on_attach = on_clangd_attach,
        capabilities = g_capabilities,
    }

    local current_client = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })[1]
    if current_client then
        vim.lsp.stop_client(current_client.id)
    end

    vim.lsp.start(new_config)
end

-----------------------------------------------------------------------------------------
-- Python 配置
------------------------------------------------------------------------------------------
lspconfig.pyright.setup({
    filetypes = { "py", "python" },
    on_attach = function(_, bufnr)
        local telescope = require("telescope.builtin")
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", telescope.lsp_implementations, opts)
        vim.keymap.set("n", "gr", telescope.lsp_references, opts)
        vim.keymap.set("n", "gl", telescope.lsp_document_symbols, opts)
        vim.keymap.set("n", "ga", telescope.lsp_dynamic_workspace_symbols, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, opts)
        vim.keymap.set("n", "<leader>fx", vim.lsp.buf.code_action, opts)
        vim.keymap.set("i", "<M-k>", vim.lsp.buf.signature_help, opts)
    end,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "warning",
                    reportUnusedVariable = "warning",
                    reportMissingImports = "error",
                    reportUnusedFunction = "warning",
                },
            },
        },
    },
})

-----------------------------------------------------------------------------------------
-- 诊断符号
------------------------------------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = { prefix = "■", source = "always" },
    update_in_insert = false,
    severity_sort = true,
    float = { source = "always" },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.INFO] = "✶",
            [vim.diagnostic.severity.HINT] = "☀",
        },
    },
})

-----------------------------------------------------------------------------------------
-- nvim-cmp 配置
------------------------------------------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    performance = { max_view_entries = 30 },
    window = {
        completion = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            scrollbar = false,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            max_width = 50,
            min_width = 20,
        },
        documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            scrollbar = false,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            max_height = 25,
        },
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<M-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            elseif luasnip.choice_active() then
                luasnip.change_choice(1)
            else
                cmp.complete()
            end
        end, { "i", "s" }),

        ["<M-h>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<M-l>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        {
            name = "nvim_lsp",
            entry_filter = function(entry)
                return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end,
        },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = "menuone,noselect,insert,preview",
    },
})

return M
