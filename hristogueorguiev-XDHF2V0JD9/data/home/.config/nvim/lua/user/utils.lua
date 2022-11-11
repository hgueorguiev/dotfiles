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
   completrion = "file",
   default = "**/*."
  },
  process_glob)
end

return utils_module
