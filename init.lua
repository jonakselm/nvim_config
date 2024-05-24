vim.cmd(
[[call plug#begin()
Plug 'ray-x/lsp_signature.nvim'

call plug#end()
]])

require "lsp_signature".setup()

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
		--local client = vim.lsp.get_client_by_id(ev.data.client_id)
		--require'lsp_compl'.attach(client, ev.buf, { trigger_on_delete = true })
	end
})


vim.cmd([[
	" Goes through the option list if there is one, else tab
	inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
]])

vim.keymap.set('i', 'jj', '<esc>')
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4 
vim.opt.relativenumber = true


vim.api.nvim_set_hl(0, 'LineNr', { fg = "yellow" })
