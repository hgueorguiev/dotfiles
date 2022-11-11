local return_code, utils = pcall(require, 'user.utils') 
local return_code, t_builtin = pcall(require, 'telescope.builtin')
local return_code, gps = pcall(require, 'nvim-gps')

--------------------------------------------------------------------------------
-- Setup editor options
--------------------------------------------------------------------------------
vim.go.viminfo = vim.go.viminfo..',n~/.cache/.viminfo'
vim.opt.mouse = 'a'
vim.opt.colorcolumn = "120"
---- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
---- Case for find
vim.opt.ignorecase = true
vim.opt.smartcase = true
---- Wrap
vim.opt.wrap = true
vim.opt.breakindent = true
---- Tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
---- Colors
vim.opt.termguicolors = true
vim.cmd('colorscheme afterglow')
vim.cmd('hi Normal guibg=none') -- Remove background
---- Space as leader
vim.g.mapleader = ' '

--------------------------------------------------------------------------------
-- Custom commands
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})

--------------------------------------------------------------------------------
-- Key bindings/ mappings
--------------------------------------------------------------------------------
vim.keymap.set('n', '<C-s>', ':w<CR>', {remap = false})
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>a', {remap = false})
vim.keymap.set('n', '<LEADER>h', ':noh<CR>', {remap = false})
vim.keymap.set('i', 'jk', '<ESC>', {}) 

---- Buffer nav
vim.keymap.set('n', 'H', ':bp<CR>', {remap = false})
vim.keymap.set('n', 'L', ':bn<CR>', {remap = false})
vim.keymap.set('n', '<LEADER>c', ':bd<CR>', {remap = false})

---- Telescope
vim.keymap.set('n', '<leader>ff', t_builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', t_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', t_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', t_builtin.help_tags, {}) 
vim.keymap.set('n', '<leader>fs', utils.grep_in_blob, {}) 
vim.keymap.set('n', '<leader>fr', t_builtin.resume, {}) 
vim.keymap.set('n', '<leader>fo', t_builtin.oldfiles, {}) 

--------------------------------------------------------------------------------
-- Plugin manager
--------------------------------------------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local install_plugins = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print('Installing packer...')
  local packer_url = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
  print('Done.')

  vim.cmd('packadd packer.nvim')
  install_plugins = true
end

require('packer').startup(function(use)
  ---- List of plugins...
  ------ Lib. plugins
  use "nvim-lua/plenary.nvim"
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  ------ Telescope finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
                             -- or , branch = '0.1.x',
    requires = {
      {'nvim-lua/plenary.nvim'}
    }
  }
  ------ Package manager
  use 'wbthomason/packer.nvim'
  ------ Status lines
  use 'nvim-lualine/lualine.nvim'
  -- use {
  -- 'kdheepak/tabline.nvim',
  -- config = function()
  --     require'tabline'.setup {
  --       -- Defaults configuration options
  --       enable = true,
  --       options = {
  --       -- If lualine is installed tabline will use separators configured in lualine by default.
  --       -- These options can be used to override those settings.
  --         section_separators = {'', ''},
  --         component_separators = {'', ''},
  --         max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
  --         show_tabs_always = false, -- this shows tabs only when there are more than one tab or if the first tab is named
  --         show_devicons = true, -- this shows devicons in buffer section
  --         show_bufnr = false, -- this appends [bufnr] to buffer section,
  --         show_filename_only = false, -- shows base filename only instead of relative path in filename
  --         modified_icon = "+ ", -- change the default modified icon
  --         modified_italic = true, -- set to true by default; this determines whether the filename turns italic if modified
  --         show_tabs_only = false, -- this shows only tabs instead of tabs + buffers
  --       }
  --     }
  --     vim.cmd[[
  --       set guioptions-=e " Use showtabline in gui vim
  --       set sessionoptions+=tabpages,globals " store tabpages and globals in session
  --     ]]
  --   end,
  --   requires = { { 'hoob3rt/lualine.nvim', opt=true }, {'kyazdani42/nvim-web-devicons', opt = true} }
  -- }
  ------ Code introspection
  use { -- Code parser
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use { -- Code object insights
    'SmiteshP/nvim-gps',
    requires = 'nvim-treesitter/nvim-treesitter',
  }
  use { -- Smart comments
    'numToStr/Comment.nvim',
  }
  use { -- GIT integration
  'lewis6991/gitsigns.nvim',
  }
  ------ Objects & Motions
  use { 'tpope/vim-surround' } -- Add suround objects
  use { 'bkad/CamelCaseMotion' } -- Add word case objects
  use 'ggandor/leap.nvim' -- Match jumps
  ------ Colorschemes/ Style
  use 'danilo-augusto/vim-afterglow'
  use 'nvim-tree/nvim-web-devicons'
  ---- List of plugins end

  if install_plugins then
    require('packer').sync()
  end
end)

---- Stop config init to allow plugin installation
if install_plugins then
  print('Config init interupted to allow plugin installation. Reload')
  return
end


--------------------------------------------------------------------------------
-- Plugin Configuration
--------------------------------------------------------------------------------
---- Lua Line
require('lualine').setup({
   options = {
     icons_enabled = true,
     section_separators = '*',
     component_separators = '#'
   }
})

---- Treesitter
require('nvim-treesitter.configs').setup({highlight={enable=true}})

---- Leap
require('leap').add_default_mappings()

---- Comment
require('Comment').setup()

---- GPS
require('nvim-gps').setup()

---- GIT Signs
require('gitsigns').setup({
  current_line_blame = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

---- Dev icons
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };

 color_icons = true;
 -- globally enable default icons (default to false)
 default = true;
}
