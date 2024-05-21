vim.cmd(
[[call plug#begin()
		
" lsp
Plug 'prabirshrestha/vim-lsp'

" autocomplete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mfussenegger/nvim-lsp-compl'

" highlighting
Plug 'jackguo380/vim-lsp-cxx-highlight'

" snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Function signatures
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

--vim.cmd([[
--if executable('clangd')
--    augroup lsp_clangd
--        autocmd!
--        autocmd User lsp_setup call lsp#register_server({
--                    \ 'name': 'clangd',
--                    \ 'cmd': {server_info->['clangd']},
--                    \ 'initialization_options': {
--                    \   'highlight': { 'lsRanges' : v:true },
--                    \ },
--                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
--                    \ })
--        autocmd FileType c setlocal omnifunc=lsp#complete
--        autocmd FileType cpp setlocal omnifunc=lsp#complete
--        autocmd FileType objc setlocal omnifunc=lsp#complete
--        autocmd FileType objcpp setlocal omnifunc=lsp#complete
--    augroup end
--endif
--]])

vim.cmd([[
	" Goes through the option list if there is one, else tab
	inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
	

	" Quality of life changes
	" inoremap jj <ESC>
	" set tabstop=4
	" set shiftwidth=4
	" set relativenumber
]])

vim.keymap.set('i', 'jj', '<esc>')
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4 
vim.opt.relativenumber = true


vim.api.nvim_set_hl(0, 'LineNr', { fg = "yellow" })
--"let g:lsp_semantic_enabled = 1
--"let g:lsp_cxx_hl_use_text_props = 1
--hi Comment ctermfg=DarkGreen
