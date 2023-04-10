local utils_module = {}
-- Load module or install with Packer
function utils_module.require_and_sync(module)
  local function requiref(module)
    require(module)
  end
  res, mod = pcall(require, module)
  if not(res) then
    require('packer').sync()
    return require(module)
  end

  return mod
end

-- Debug info to help with new init.lua setup
function utils_module.debug_info()
  print('TEST: Module functions callable!')
  print('Config path: '..vim.fn.stdpath('config'))
end  

-- Grep for value in search register with Telescope.livegrep
function utils_module.grep_on_search_register()
  require('telescope.builtin').live_grep({
      default_text=string.gsub(string.gsub(vim.fn.getreg('/'), '\\<', ''), '\\>', '')
  })
end

-- Toggle a split with terminal
function utils_module.toggle_terminal_split()
  local buf_type = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'buftype')

  function make_term_buf()
    vim.cmd('ter')
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.g.term_buffer_id = cur_buf
  end

  if buf_type == 'terminal' then
    vim.cmd('wincmd c')
    return
  end

  vim.cmd('sp')
  local command = 'b ' .. (vim.g.term_buffer_id or 'DnE')
  if not pcall(vim.cmd, command) then
    make_term_buf()
  end
end

-- Telescope helper grep in blob
local telescope_grep_in_blob = function(glob_pattern)
  require('telescope.builtin').live_grep({glob_pattern=glob_pattern})
end

function utils_module.grep_in_blob()

  local process_glob = function(glob_string)
    print("Searching in globs: ", glob_string)
    
    local glob_patterns = {}
    for w in glob_string:gmatch("([^,]+)") do 
      -- print('P: "', w,'"') 
      table.insert(glob_patterns, w) 
    end
    
    telescope_grep_in_blob(glob_patterns)
  end
  
  vim.ui.input({
   prompt = "Search in glob:",
   completion = "file",
   default = "**/*."
  },
  process_glob)
end

--------------------------------------------------------------------------------
-- From LUNAR Vim
--------------------------------------------------------------------------------
--- Checks whether a given path exists and is a file.
--@param path (string) path to check
--@returns (bool)
function utils_module.is_file(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "file" or false
end

--- Checks whether a given path exists and is a directory
--@param path (string) path to check
--@returns (bool)
function utils_module.is_directory(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type == "directory" or false
end

utils_module.join_paths = _G.join_paths
--------------------------------------------------------------------------------

return utils_module
