local function get_promptlibs_base_path()
    return vim.fn.stdpath("config") .. "/lua/config/codecomp/prompt_library/"
end

return {
    -- ["Generate a Commit Message"] = require('config.codecomp.prompt_library.commit_message'),
    markdown = {
      dirs = {
          get_promptlibs_base_path() .. 'markdown'
      },
    },
}
