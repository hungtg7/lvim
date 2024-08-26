-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--
--
--   Color scheme
-- User plugin
lvim.plugins = {
    { 'kevinhwang91/promise-async' },
    {
        "hadronized/hop.nvim",
        config = function()
            require("hop").setup({})
        end,
    },                           -- Hop around file easymotion
    { 'kevinhwang91/nvim-ufo' }, -- ufo require promise-async
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup({
                enabled = true,
                events = { "InsertLeave" },
                conditions = {
                    exists = true,
                    filename_is_not = {},
                    filetype_is_not = {},
                    modifiable = true
                },
                write_all_buffers = false,
                on_off_commands = true,
                clean_command_line_interval = 0,
                debounce_delay = 135
            })
        end,
    },
    { "tpope/vim-surround" } -- Easy to modify brackets
}

-- Vim settings
vim.opt.wrap = true               -- line break
vim.opt.mouse = 'a'               -- enable mouse support
vim.opt.clipboard = 'unnamedplus' -- copy/paste to system clipboard
vim.opt.swapfile = false          -- don't use swapfile
vim.opt.undofile = true           -- enable persistent undo
vim.opt.number = true             -- show line number
vim.opt.relativenumber = true     -- set relative number
vim.opt.showmatch = true          -- highlight matching parenthesis
vim.opt.foldmethod = 'marker'     -- enable folding (default 'foldmarker')
vim.opt.splitright = true         -- vertical split to the right
vim.opt.splitbelow = true         -- orizontal split to the bottom
vim.opt.linebreak = true          -- wrap on word boundary
vim.opt.hidden = true             -- enable background buffers
vim.opt.history = 100             -- remember n lines in history
vim.opt.lazyredraw = true         -- faster scrolling
vim.opt.updatetime = 300          -- faster completion (4000ms default)
vim.opt.synmaxcol = 240           -- max column for syntax highlight
vim.opt.termguicolors = true      -- enable 24-bit RGB colors
vim.opt.expandtab = true          -- use spaces instead of tabs
vim.opt.shiftwidth = 4            -- shift 4 spaces when tab
vim.opt.tabstop = 4               -- 1 tab == 4 spaces
vim.opt.ignorecase = true         -- ignore case letters when search
vim.opt.smartcase = true          -- ignore lowercase for the whole pattern
vim.opt.smartindent = true        -- autoindent new lines
vim.opt.hlsearch = true           -- highlight all matches on previous search pattern
vim.opt.ignorecase = true         -- ignore case in search patterns
vim.opt.conceallevel = 0          -- so that `` is visible in markdown files
vim.opt.pumheight = 10            -- pop up menu height
vim.opt.numberwidth = 4           -- set number column width to 2 {default 4}
vim.opt.showmode = false          -- show current mode
vim.opt.showtabline = 2           -- always show tabs
vim.opt.scrolloff = 8             -- scroll before reach last line
vim.opt.sidescrolloff = 8
vim.opt.completeopt = 'menuone,noselect'
-- Folding code block
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldmethod = 'syntax'
vim.opt.autoindent = false

local opts = { noremap = true, silent = true }
-- Shorten function name
--
-- keymap
local keymap = vim.api.nvim_set_keymap
keymap("i", "fd", "<ESC>", opts)
keymap("x", "<leader>fm", ":lua vim.lsp.buf.range_formatting()", opts)
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Don't overwrite paste content in visual mode
keymap("v", "p", '"_dP', opts)

-- Jump faster
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)

-- Clear highlight text search
keymap('n', '<ESC>', ':nohl<CR>', opts)

-- hop keymap
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
    hop.hint_char1({ direction = directions.AFTER_CURSOR })
end, { remap = true })
vim.keymap.set('', 'F', function()
    hop.hint_char1({ direction = directions.BEFORE_CUSOR })
end, { remap = true })



-- Config core plugin
local cmp_mapping = require "cmp.config.mapping"
lvim.builtin.cmp.mapping["<CR>"] = cmp_mapping.confirm({ select = true })
lvim.format_on_save.enabled = false
lvim.format_on_save.pattern = { "*.py" }


-- Fix auti indent python, rust
lvim.builtin.treesitter.indent.disable = {}

-- Config control UI
lvim.builtin.which_key.mappings["/"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Project Grep" }
lvim.builtin.which_key.mappings["f"] = { "<cmd>Telescope current_buffer_fuzzy_find theme=ivy<cr>", "Find Text" }
lvim.builtin.which_key.mappings["<space>"] = {
    function()
        require("lvim.core.telescope.custom-finders").find_project_files { previewer = true }
    end,
    "Find File",
}
lvim.builtin.which_key.mappings["q"] = { "<cmd>BufferKill<CR>", "Close Buffer" }
lvim.builtin.which_key.mappings["p"] = { "<cmd>Telescope projects<cr>", "Projects" }
-- Folding
lvim.builtin.which_key.mappings["z"] = { "Folding code" }
lvim.builtin.which_key.mappings["zM"] = { require('ufo').closeAllFolds, "Close all Fold code" }
lvim.builtin.which_key.mappings["zM"] = { require('ufo').openAllFolds, "Open all Fold code" }
-- sellect opened buffer
lvim.builtin.which_key.mappings["<TAB>"] = { "<cmd>Telescope buffers<cr>", "Select opened buffer" }

-- Config telescrope
lvim.builtin.telescope.pickers.find_files["theme"] = "ivy"
lvim.builtin.telescope.pickers.live_grep["theme"] = "ivy"
lvim.builtin.telescope.pickers.grep_string["theme"] = "ivy"

-- read bigfile
lvim.builtin.bigfile.config = {
    filesize = 2,      -- size of the file in MiB, the plugin round file sizes to the closest MiB
    pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
    features = {       -- features to disable
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
    },
}


-- nvim tree folder
lvim.builtin.nvimtree.setup.view.adaptive_size = true


-- Python config
-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { name = "black" }, }

-- setup linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { command = "flake8", filetypes = { "python" } } }

-- theme
lvim.colorscheme = "slate"
