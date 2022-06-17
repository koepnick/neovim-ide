local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local let = vim.let

cmd 'set nocompatible'
cmd 'let g:CONFIGDIR=fnamemodify(expand("$MYVIMRC"), ":p:h")'
cmd 'let g:RUNTIMEDIR=fnamemodify(expand("$MYVIMRC"), ":p:h:h:h") . "/.local/nvim/"'
require "paq" {
    "savq/paq-nvim";
    "neovim/nvim-lspconfig";
    "nvim-treesitter/nvim-treesitter";
    "hrsh7th/cmp-nvim-lsp";
    "hrsh7th/nvim-cmp";
    "hrsh7th/cmp-path";
    -- "uga-rosa/cmp-dictionary";
    "Pocco81/AbbrevMan.nvim";
    "machakann/vim-sandwich";
    "tpope/vim-commentary";
    "kosayoda/nvim-lightbulb";
    -- "SirVer/ultisnips";
    {"junegunn/fzf", run=fn['fzf#install']};
    "junegunn/fzf.vim";

    -- Autocompletion Snippet Engine
    "L3MON4D3/LuaSnip";
    "saadparwaiz1/cmp_luasnip";

    -- Not sure what all of these do yet
    "ojroques/nvim-lspfuzzy";
    "lewis6991/gitsigns.nvim";
    "lukas-reineke/indent-blankline.nvim";
    "nvim-treesitter/nvim-treesitter-textobjects"; -- Nothing?

    -- Prose
    "vim-pandoc/vim-pandoc";
    "vim-pandoc/vim-pandoc-syntax";
    "junegunn/goyo.vim";

    "lervag/vimtex";

    -- Colors
    "joshdick/onedark.vim";
    "rafi/awesome-vim-colorschemes";

    -- IDE
    'preservim/tagbar'
}

-- Some Helpers
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

cmd 'set undofile'
cmd 'set undodir=~/.local/nvim/undo'

-- Some Native Vim Fun
cmd 'autocmd InsertEnter set timeoutlen=100'
cmd 'autocmd InsertLeave set timeoutlen=1000'
cmd 'autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}'
cmd 'autocmd BufEnter *.py colorscheme afterglow'
cmd 'autocmd InsertEnter * set timeoutlen=200'
cmd 'autocmd InsertLeave * set timeoutlen=1000'
-- cmd 'source /home/skoepnick/.config/nvim/config/normal_maps.vim'

-- cmd = 'let UltiSnipsSnippetDirectories = ["ulti", "~/.nvim/snippets/"]'

-- Basic Settings

-- vim.o.completeopt = menu,menuone,noselect
vim.o.expandtab = true
vim.o.number = true
vim.o.relativenumber = false
vim.o.joinspaces = false
vim.o.shiftround = true
vim.o.shiftwidth = 4
vim.o.termguicolors = true
-- vim.o.textwidth = 80
-- vim.o.wrap = true
-- vim.o.linebreak = true
vim.cmd("colo onedark")


local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_install = 'maintained', highlight = {enable = true}}

-- LSP (Language Server Protocol)
local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'
lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

local defaults = {noremap=true, silent=true}
map("n", "<bslash>,", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
map("n", "<bslash>;", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
map("n", "<bslash>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<bslash>d", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "<bslash>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "<bslash>h", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "<bslash>m", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<bslash>r", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<bslash>s", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
map("n", "<bslash>h", "<cmd>nohls<CR>")
map("n", "<bslash>H", "<cmd>call customhelp#CheatsheetWindow(&ft)<CR>")
map("n", "<bslash>?", "<cmd>call customhelp#CheatsheetWindow('vim')<CR>") map("n", "<bs>", "<cmd>bp<cr>")
map("n", ",,", "f,")
map("n", "//", "f/")
map("n", "bb", "<cmd>buffers<CR>")
map("n", "bd", "<cmd>bd<CR>")
map("n", "tt", "<cmd>tabs<CR>")
map("n", "t<", "<cmd>tabp<CR>")
map("n", "t>", "<cmd>tabn<CR>")
map("n", "t,", "<cmd>tabp<CR>")
map("n", "t.", "<cmd>tabn<CR>")
map("i", "<Space>", "<Space><C-g>u")
map("i", "jk", "<esc>l", defaults)

cmd("command! EditFiletype call helpers#EditFiletype(&ft)")
cmd("command! EditCheatsheet call helpers#EditCheatsheet(&ft)")

for i=1,9 do
    map("n", "b" .. i, "<cmd>b" .. i .. "<CR>")
    map("n", "t" .. i, "<cmd>tabn" .. i .. "<CR>")
end

-- Language specific
lsp.pylsp.setup {}

-- Text Objects

require 'nvim-treesitter.configs'.setup {
    textobjects = {
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["<bslash>]"] = "@function.outer",
            },
        },
        lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {
                ["<bslash>df"] = "@function.outer",
                ["<bslash>dc"] = "@class.outer",
            }
        },
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.innter",
            }
        }
    }
}

-- Auto Completion
map("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>")
map("i", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>")
map("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>")
map("s", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>")
local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ["<cr>"] = cmp.mapping.confirm(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp"}, 
        { name = "luasnip"}, 
    }),

    cmp.setup.cmdline('/', {
        sources = {
            { name = "buffer" },
        }
    })
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())


require('lspconfig')['pylsp'].setup {
    capabilities = capabilities,
    settings = {
        pylsp = {
            plugins = {
                flake8 = { 
                    enabled = true,
                    ignore = ignore_list,
                    filetypes = {"python"},
                    command = "flake8",
                    args = { "--stdin-display-name", "$FILENAME", "-"},
                },
                pycodestyle = { 
                    enabled = false,
                    ignore = ignore_list,
                }
            }
        }
    }
}
