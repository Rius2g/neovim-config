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
Plug 'nvim-telescope/telescope-file-browser.nvim'
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
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-lua/plenary.nvim'

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

" Set the leader key
let mapleader = " " " Use space as the leader key

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
-- C/C++
nvim_lsp.clangd.setup{}
-- TypeScript/React
nvim_lsp.ts_ls.setup{}

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

vim.g.dashboard_custom_footer = {'Lets get some money in the room - Lewis Reneri'}


-- Configure WhichKey
require("which-key").setup {}

local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
sources = {
    null_ls.builtins.formatting.prettier,
    },
    on_attach = function(client, bufnr)
       if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})

-- Configure Bufferline
require("bufferline").setup{
    options = {
        numbers = "ordinal",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
            icon = '›',
            style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '•',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        separator_style = "thin",
        always_show_bufferline = true,
    }
}

-- Configure Gitsigns
require('gitsigns').setup()

-- Configure lualine
require('lualine').setup {
  options = {
    theme = 'nightfly',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
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

-- Configure Telescope and File Browser
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key", -- Show key mappings in Telescope
      },
    },
  },
  extensions = {
    file_browser = {
      hijack_netrw = true, -- Disable netrw and use Telescope File Browser
    },
  },
}

-- Load Telescope Extensions
require('telescope').load_extension('file_browser')

vim.api.nvim_create_user_command(
'E',
function()
require('telescope.builtin').find_files()
end,
{desc = "Open Telescope file finder"}
)


-- Keybindings for Telescope File Browser
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope file_browser<CR>', { desc = "Open File Browser" })
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = "Open File Browser in Current Directory" })

-- Telescope LSP Keybindings
vim.keymap.set('n', 'gd', function()
  require('telescope.builtin').lsp_definitions({
    fname_width = 50,
  })
end, { desc = "Go to Definition" })

vim.keymap.set('n', 'gr', function()
  require('telescope.builtin').lsp_references({
    fname_width = 50,
    include_declaration = false,
  })
end, { desc = "Find References" })

vim.keymap.set('n', 'gi', function()
  require('telescope.builtin').lsp_implementations({
    fname_width = 50,
  })
end, { desc = "Find Implementations" })

vim.keymap.set('n', '<leader>ds', function()
  require('telescope.builtin').lsp_document_symbols()
end, { desc = "Document Symbols" })

vim.keymap.set('n', '<leader>ws', function()
  require('telescope.builtin').lsp_workspace_symbols({
    query = vim.fn.input("Symbol Query: "),
  })
end, { desc = "Workspace Symbols" })

EOF

