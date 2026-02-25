return {
    vectorcode = { -- pip install VectorCode
        ---@type VectorCode.CodeCompanion.ExtensionOpts
        opts = {
            tool_group = {
                -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
                enabled = true,
                -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
                -- if you use @vectorcode_vectorise, it'll be very handy to include
                -- `file_search` here.
                extras = {},
                collapse = false, -- whether the individual tools should be shown in the chat
            },
            tool_opts = {
                ---@type VectorCode.CodeCompanion.ToolOpts
                ["*"] = {},
                ---@type VectorCode.CodeCompanion.LsToolOpts
                ls = {},
                ---@type VectorCode.CodeCompanion.VectoriseToolOpts
                vectorise = {},
                ---@type VectorCode.CodeCompanion.QueryToolOpts
                query = {
                    max_num = { chunk = -1, document = -1 },
                    default_num = { chunk = 50, document = 10 },
                    include_stderr = false,
                    use_lsp = false,
                    no_duplicate = true,
                    chunk_mode = true,
                    ---@type VectorCode.CodeCompanion.SummariseOpts
                    summarise = {
                        ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
                        enabled = false,
                        adapter = nil,
                        query_augmented = true,
                    },
                },
                files_ls = {},
                files_rm = {},
            },
        },
    },
}
