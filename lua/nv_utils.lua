local function set_filetype_keymaps(ft, map_cmd, lhs, rhs, opts)
    local cmd = string.format('%s("%s", "%s", %s)', map_cmd, lhs, rhs, vim.inspect(opts))
    vim.cmd(string.format('autocmd FileType %s %s', ft, cmd))
end

local function autocmd(...)
    local args = { ... }                                       -- 使用...收集所有变长参数
    local joinedCmd = "autocmd " .. table.concat(args, " ") -- 拼接参数，并在前面添加"autocmd "
    vim.cmd(joinedCmd)
end

return { set_filetype_keymaps = set_filetype_keymaps, autocmd = autocmd }
