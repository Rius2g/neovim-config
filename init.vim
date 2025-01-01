" init.vim

" Vim-Plug setup
call plug#begin('~/.vim/plugged')
" Language Server Protocol (LSP) support
Plug 'neovim/nvim-lspconfig'
" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" File explorer
Plug 'nvim-tree/nvim-tree.lua'
" Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" GitHub Copilot
Plug 'github/copilot.vim'
" Theme
Plug 'folke/tokyonight.nvim'
" Dashboard
Plug 'glepnir/dashboard-nvim'
" Telescope
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plugins for enhanced look and functionality
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'bluz71/vim-nightfly-guicolors'
" New plugins
Plug 'folke/which-key.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'folke/zen-mode.nvim'
Plug 'folke/twilight.nvim'
Plug 'norcalli/nvim-colorizer.lua'
call plug#end()

" Basic settings
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set mouse=a
set cursorline
set hidden
set noshowmode
set laststatus=2
set signcolumn=yes

" Theme settings
set termguicolors
colorscheme nightfly
let g:nightflycursorcolor = 1
let g:nightflyitalics = 1

" Enhanced keybindings
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <C-p> :Telescope find_files<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Additional customizations for a more intense look
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guifg=#4d5154 ctermfg=239
highlight CursorLineNr guifg=#e2e4e5 ctermfg=254
highlight Comment guifg=#608b4e ctermfg=71

" Additional keybindings for new features
nnoremap <leader>z :ZenMode<CR>
nnoremap <leader>t :Twilight<CR>

" Lua configuration
lua << EOF
local nvim_lsp = require('lspconfig')
-- Go
nvim_lsp.gopls.setup{}
-- Rust
nvim_lsp.rust_analyzer.setup{}
-- C/C++
nvim_lsp.clangd.setup{}
-- TypeScript/React
nvim_lsp.tsserver.setup{}

-- Autocompletion setup
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Configure Dashboard
vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_custom_section = {
    a = {description = {'  Find File          '}, command = 'Telescope find_files'},
    b = {description = {'  Recently Used Files'}, command = 'Telescope oldfiles'},
    c = {description = {'  Load Last Session  '}, command = 'SessionLoad'},
    d = {description = {'  Find Word          '}, command = 'Telescope live_grep'},
    e = {description = {'  Settings           '}, command = ':e ~/.config/nvim/init.vim'}
}

vim.g.dashboard_custom_footer = {'Do one thing, do it well - Unix philosophy'}

-- Configure WhichKey
require("which-key").setup {}

-- Configure Bufferline
require("bufferline").setup{
    options = {
        numbers = "ordinal",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
            icon = '▎',
            style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        custom_filter = function(buf_number)
            if vim.bo[buf_number].filetype ~= "qf" then
                return true
            end
        end,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = true,
        always_show_bufferline = true,
    }
}

-- Configure Gitsigns
require('gitsigns').setup()

-- Configure lualine for a more badass statusline
require('lualine').setup {
  options = {
    theme = 'nightfly',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {{'mode', separator = { left = '', right = ''}, right_padding = 2}},
    lualine_b = {{'branch', icon = ''}, 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {{'location', separator = { left = '', right = ''}, left_padding = 2}}
  },
}

-- Configure Zen Mode
require("zen-mode").setup {
    window = {
        width = .85,
        options = {
            number = true,
            relativenumber = true,
        }
    },
}

-- Configure Twilight
require("twilight").setup {
    dimming = {
        alpha = 0.25,
        color = { "Normal", "#ffffff" },
        inactive = false,
    },
    context = 10,
    treesitter = true,
    expand = {
        "function",
        "method",
        "table",
        "if_statement",
    },
}

-- Configure Colorizer
require'colorizer'.setup()
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local opts = {buffer = 0}
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end,
  group = vim.api.nvim_create_augroup("TerminalMappings", {clear = true}),
})

-- Define a custom command to open a terminal in a vertical split
vim.api.nvim_create_user_command('Vterm', function(opts)
    -- Calculate the width of the new terminal split
    local width = 120  -- Default width
    if opts.args ~= "" then
        width = tonumber(opts.args) or 120
    end

    -- Open a vertical split
    vim.cmd('vsplit')

    -- Resize the split to the specified width
    vim.cmd('vertical resize ' .. width)

    -- Open terminal in the new split
    vim.cmd('terminal')

    -- Optional: Switch to insert mode automatically
    vim.cmd('startinsert')
end, { nargs = '?', desc = 'Open a terminal in a vertical split' })

-- Optional: Create a keymap for quick access
vim.keymap.set('n', '<leader>vt', ':Vterm<CR>', { noremap = true, silent = true, desc = 'Open vertical terminal' })

-- Add a mapping to easily close terminal buffer from normal mode
vim.keymap.set('n', '<leader>tc', ':bdelete!<CR>', { noremap = true, silent = true, desc = 'Close terminal buffer' })
EOF
