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
Plug 'kylechui/nvim-surround'
Plug 'goolord/alpha-nvim'

" Terminal toggler
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
" Speed up startup time
Plug 'lewis6991/impatient.nvim'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" File explorer
Plug 'nvim-tree/nvim-tree.lua'

"Fuzzy finder
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
Plug 'goolord/alpha-nvim'
" Telescope
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plugins for enhanced look and functionality
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'windwp/nvim-autopairs'
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
set showtabline=2
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
nnoremap <leader>Fg :vsplit<CR>:Telescope live_grep<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Terminal in splits
nnoremap <leader>ts :split<CR>:terminal<CR>i
nnoremap <leader>tv :vsplit<CR>:terminal<CR>i

" Buffers 
nnoremap <Tab> :BufferLineCycleNext<CR>
nnoremap <S-Tab> :BufferLineCyclePrev<CR>

" Definition in split 
nnoremap <leader>sd :split<CR>:lua vim.lsp.buf.definition()<CR>
nnoremap <leader>sv :vsplit<CR>:lua vim.lsp.buf.definition()<CR>

" Quick file navigation
nnoremap <leader>fs :split<CR>:Telescope find_files<CR>
nnoremap <leader>fv :vsplit<CR>:Telescope find_files<CR>

" Buffer management in splits
nnoremap <leader>bs :split<CR>:Telescope buffers<CR>
nnoremap <leader>bv :vsplit<CR>:Telescope buffers<CR>

" Project-wide search in different windows
nnoremap <leader>pw :split<CR>:Telescope grep_string<CR>
nnoremap <leader>pW :vsplit<CR>:Telescope grep_string<CR>

" Git operations
nnoremap <leader>gs :split<CR>:Telescope git_status<CR>
nnoremap <leader>gc :vsplit<CR>:Telescope git_commits<CR>

" Bufferline keybindings
nnoremap <leader>bd :bdelete<CR>           
nnoremap <leader>bn :bnext<CR>              
nnoremap <leader>bp :bprevious<CR>           

nnoremap <leader>cm <cmd>Telescope commands<CR>                   
nnoremap <leader>km <cmd>Telescope keymaps<CR>                   
nnoremap <leader>sh <cmd>Telescope search_history<CR>           

" Quick help
nnoremap <leader>hs :split<CR>:Telescope help_tags<CR>

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
pcall(require, 'impatient')
local lspconfig = require('lspconfig')

-- Correctly setup LSP servers
local ts = lspconfig.ts_ls or lspconfig.tsserver
ts.setup({})
lspconfig.gopls.setup {}
lspconfig.clangd.setup {}

require('lualine').setup({
  options = {
    theme = 'nightfly',
    section_separators = '',
    component_separators = '',
  },
})

require("bufferline").setup({
  options = {
    mode = "buffers",
    separator_style = "slant",
    diagnostics = "nvim_lsp",
  },
})

require("nvim-surround").setup({})
require('nvim-autopairs').setup({})

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

-- Prettier autoformat on save using null-ls
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

-- Toggleterm terminals with auto-close
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", close_on_exit = true })
local lf = Terminal:new({ cmd = "lf", direction = "float", close_on_exit = true })
local htop = Terminal:new({ cmd = "htop", direction = "float", close_on_exit = true })

vim.keymap.set("n", "<leader>lg", function() lazygit:toggle() end, { desc = "Lazygit (float)" })
vim.keymap.set("n", "<leader>lf", function() lf:toggle() end, { desc = "LF File Manager (float)" })
vim.keymap.set("n", "<leader>ht", function() htop:toggle() end, { desc = "Htop (float)" })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- Alpha Dashboard
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  ' ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠛⠛⠉⠉⠉⠉⠉⠛⠛⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ ',
  ' ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ ',
  ' ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ ',
  ' ⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿ ',
  ' ⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿ ',
  ' ⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿ ',
  ' ⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿ ',
  ' ⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿ ',
  ' ⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿ ',
  ' ⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿ ',
  ' ⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿ ',
  ' ⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿ ',
  '',
  '                       NAH, I\'D WIN                       ',
  '',
}

dashboard.section.buttons.val = {
  dashboard.button("f", "📂  Find file", ":Telescope find_files<CR>"),
  dashboard.button("r", "🕘  Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("g", "🔍  Grep text", ":Telescope live_grep<CR>"),
  dashboard.button("c", "   Edit config", ":e ~/.config/nvim/init.vim<CR>"),
  dashboard.button("l", "🧠  Lazygit", function() vim.schedule(function() lazygit:toggle() end) end),
  dashboard.button("e", "📁  LF File Explorer", function() vim.schedule(function() lf:toggle() end) end),
  dashboard.button("h", "📊  Htop Monitor", function() vim.schedule(function() htop:toggle() end) end),
  dashboard.button("q", "❌  Quit Neovim", ":qa<CR>"),
}

dashboard.section.footer.val = function()
  return {
    "🎯 " .. os.date("%A, %B %d %Y  %H:%M"),
    "🚀 Neovim loaded " .. vim.fn.len(vim.fn.globpath('~/.vim/plugged', '*', 0, 1)) .. " plugins"
  }
end

alpha.setup(dashboard.opts)
EOF

