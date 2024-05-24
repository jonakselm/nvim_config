vim.cmd(
[[call plug#begin()
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Function signatures
Plug 'ray-x/lsp_signature.nvim'

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

call plug#end()
]])

local cfg =
{
	select_signature_key = '<m-n>',
}

require'nvim-treesitter.configs'.setup(
{
	ensure_installed = { "c", "cpp" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true
	},
})

require "lsp_signature".setup(cfg)

local cmp = require'cmp'

cmp.setup({
	snippet = {
	-- REQUIRED - you must specify a snippet engine
	expand = function(args)
	vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
	end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
	['<C-b>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
	['<C-Space>'] = cmp.mapping.complete(),
	['<esc>'] = cmp.mapping.abort(),
	['<tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		}, {
		{ name = 'buffer' },
	})
})

-- Unlocks the god forsaken snippets
--local capabilities = require('cmp_nvim_lsp').default_capabilities()
--	require('lspconfig')['clangd'].setup {
--		capabilities = capabilities
--}

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, 
{
	pattern = { "*.c", "*.h", "*.cpp", "*.hpp"},
	callback = function(ev)
		vim.lsp.start(
		{
			name = 'clangd',
			cmd = {'clangd'},
			root_dir = vim.fs.root(0, {'CMakeLists.txt', 'meson.build'}),
		})
	end
})

vim.api.nvim_create_autocmd('LspAttach',
{
	callback = function(ev)
		vim.keymap.set('i', '<c-space>', '<c-x><c-o>')
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references)
		vim.cmd(":TSEnable cpp [{'cpp'}, {'hpp'}, {'h'}]")
		vim.cmd(":TSEnable c [{'c'}}]")
		--local client = vim.lsp.get_client_by_id(ev.data.client_id)
		--require'lsp_compl'.attach(client, ev.buf, { trigger_on_delete = true })
	end
})


vim.cmd([[
	" Goes through the option list if there is one, else tab
	inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
	

	" Quality of life changes
	" inoremap jj <ESC>
	" set tabstop=4
	" set shiftwidth=4
	" set relativenumber
	highlight @lsp.type.macro guifg=#d467f9
	highlight @lsp.type.class guifg=#67f991
	highlight @lsp.type.enum guifg=#67f991
	highlight @lsp.type.enumMember guifg=#e0f180
	highlight @lsp.type.namespace guifg=#fa604e
	highlight @lsp.type.parameter guifg=#67c0ac
]])

vim.keymap.set('i', 'jj', '<esc>')
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4 
vim.opt.relativenumber = true


vim.api.nvim_set_hl(0, 'LineNr', { fg = "yellow" })
