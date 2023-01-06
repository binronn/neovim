local myAutoGroup = vim.api.nvim_create_augroup("myAutoGroup", {
  clear = true,
})

local autocmd = vim.api.nvim_create_autocmd


--[[autocmd(]]
    --[[{ "FileType" },]]
    --[[{ pattern = { "*.json" }, command = "syntax match Comment +\/\/.\+$+" }]]
--[[)]]
