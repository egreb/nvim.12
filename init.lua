
-- autocommands

-- Highlight when yanking (copying) text
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
})

-- restore cursor pos on file open
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local line = vim.fn.line("'\"")
		if line > 1 and line <= vim.fn.line("$") then
			vim.cmd("normal! g'\"")
		end
	end,
})

-- disable automatic comment on newline
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})


-- plugins
vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig', 		-- lspconfig
	'https://github.com/christoomey/vim-tmux-navigator', 	-- tmux navigation between panes
	'https://github.com/mason-org/mason.nvim',		-- binary handler
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
    	{ src = "https://github.com/ibhagwan/fzf-lua" },
})

-- options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus'

-- keymaps
local keymap = vim.keymap.set
keymap('n', '<leader>cu', ':update<CR> :source<CR>')	-- source config
keymap('n', '<leader>w', ':write<CR>')			-- write
keymap('n', '<leader>q', ':quit<CR>')			-- quit
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')		-- clear current search
keymap("n", "<leader>ff", "<cmd>FzfLua files<CR>")
keymap("n", "<leader>fg", "<cmd>FzfLua grep_project<CR>")
keymap("n", "<leader>fr", "<cmd>FzfLua grep_last<CR>")
keymap("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>")
keymap("n", "<leader><leader>", "<cmd>FzfLua buffers<CR>")

-- lsp
vim.lsp.enable({
	'gopls',
	'lua_ls',
	'ts_ls',
})
vim.diagnostic.config({ virtual_text = true })

-- setups
require("mason").setup({})

-- blink
---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    keymap = {
        preset = "default",
	['<CR>'] = { 'accept', 'fallback' },
        -- ["<C-space>"] = {},
        -- ["<C-p>"] = {},
        -- ["<Tab>"] = {},
        -- ["<S-Tab>"] = {},
        -- ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
        -- ["<C-n>"] = { "select_and_accept" },
        -- ["<C-k>"] = { "select_prev", "fallback" },
        -- ["<C-j>"] = { "select_next", "fallback" },
        -- ["<C-b>"] = { "scroll_documentation_down", "fallback" },
        -- ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        -- ["<C-l>"] = { "snippet_forward", "fallback" },
        -- ["<C-h>"] = { "snippet_backward", "fallback" },
        -- ["<C-e>"] = { "hide" },
    },


    appearance = {
        -- use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
    },

    cmdline = {
        keymap = {
            preset = "inherit",
            ["<CR>"] = { "accept_and_enter", "fallback" },
        },
    },

    sources = { default = { "lsp" } },
})

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
    winopts = {
        height = 1,
        width = 1,
        backdrop = 85,
        preview = {
            horizontal = "right:70%",
        },
    },
    keymap = {
        builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
        },
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"] = actions.file_edit_or_qf,
        },
    },
})
