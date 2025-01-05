-- ~/.config/nvim/lua/dap-config.lua

local dap = require('dap')
local dapui = require('dapui')


vim.g.debuger_short = false
-- 配置 nvim-dap-ui
dapui.setup()
require('nvim-dap-virtual-text').setup()

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '➡️', texthl = '', linehl = '', numhl = '' })

-----------------------------------------------
-- 快捷键设置
-----------------------------------------------
---
local function setup_debug_keymaps()
  if vim.g.debuger_short == true then
    return
  else
    vim.g.debuger_short = true
  end
  -- 设置调试快捷键
  vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F9>', '<cmd>lua require"dap".toggle_breakpoint()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<F12>', '<cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>dv', '<cmd>lua require"dapui".eval()<CR>', { noremap = true, silent = true })
end

local function clear_debug_keymaps()
  if vim.g.debuger_short == false then
    return
  else
    vim.g.debuger_short = false
  end
  -- 删除调试快捷键
  -- vim.api.nvim_del_keymap('n', '<F5>')
  vim.api.nvim_del_keymap('n', '<F9>')
  vim.api.nvim_del_keymap('n', '<F10>')
  vim.api.nvim_del_keymap('n', '<F11>')
  vim.api.nvim_del_keymap('n', '<F12>')
  vim.api.nvim_set_keymap('n', '<leader>dv', '<cmd>lua require"dapui".eval()<CR>', { noremap = true, silent = true })
end

-- 设置 <leader>dr 的映射 启动调试器
vim.api.nvim_set_keymap('n', '<leader>dr', '', {
  noremap = true,
  silent = true,
  callback = function()
    -- 设置 vim.g.build_bin_path 为空
    vim.g.build_bin_path = ''
    
    -- 执行 dap.continue()
    require('dap').continue()
  end,
})

-- 只跳转到下一个错误
vim.api.nvim_set_keymap('n', '<leader>de', '<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>', { noremap = true, silent = true })
-- 只跳转到上一个错误
vim.api.nvim_set_keymap('n', '<leader>dE', '<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>', { noremap = true, silent = true })

-- 只跳转到下一个错误
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })<CR>', { noremap = true, silent = true })
-- 只跳转到上一个错误
vim.api.nvim_set_keymap('n', '<leader>dD', '<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })<CR>', { noremap = true, silent = true })



-- 监听调试器启动事件
dap.listeners.after.event_initialized['dapui_config'] = function()
  setup_debug_keymaps()  -- 设置快捷键
  dapui.open()           -- 打开 dapui
end

-- 监听调试器终止事件
dap.listeners.before.event_terminated['dapui_config'] = function()
  -- clear_debug_keymaps()  -- 删除快捷键
  dapui.close()          -- 关闭 dapui
end

-- 监听调试器退出事件
dap.listeners.before.event_exited['dapui_config'] = function()
  -- clear_debug_keymaps()  -- 删除快捷键
  dapui.close()          -- 关闭 dapui
end

-- 配置 C++ 调试
dap.adapters.gdb = {
  id='gdb',
  type = 'executable',
  command = 'gdb',  -- GDB 的可执行文件
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      -- local path = ''
      if vim.fn.filereadable(vim.g.build_bin_path) == 1 then
        path = vim.g.build_bin_path
      elseif vim.fn.isdirectory(vim.g.build_dir) == 1 then
        vim.g.build_bin_path = vim.fn.input('Path to executable: ', vim.g.build_dir .. '/', 'file')
        path = vim.g.build_bin_path
      else
        vim.g.build_bin_path = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        path = vim.g.build_bin_path
      end
      return path
    end,
    args = {},
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'enable pretty printing',
        ignoreFailures = false
      },
    },
    stopAtBeginningOfMainSubprogram = true,
  },
}


-- 配置 Python 调试
require('dap-python').setup('python3')
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = function()
      return 'python3'
    end,
  },
}


-- dap.configurations.cpp = {
--   {
--     name = "Launch",
--     type = "gdb",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = "${workspaceFolder}",
--     stopAtBeginningOfMainSubprogram = true,
--   },
--   {
--     name = "Select and attach to process",
--     type = "gdb",
--     request = "attach",
--     program = function()
--        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     pid = function()
--        local name = vim.fn.input('Executable name (filter): ')
--        return require("dap.utils").pick_process({ filter = name })
--     end,
--     cwd = '${workspaceFolder}'
--   },
--   {
--     name = 'Attach to gdbserver :1234',
--     type = 'gdb',
--     request = 'attach',
--     target = 'localhost:1234',
--     program = function()
--        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}'
--   },
-- }
 


