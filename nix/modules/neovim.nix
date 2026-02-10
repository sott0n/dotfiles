{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      " Install vim-plug if not yet installed
      if empty(glob('~/.config/nvim/autoload/plug.vim'))
          silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
            \ https://raw.github.com/junegunn/vim-plug/master/plug.vim
          autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
      endif

      """"""""""""""""""""""""""""""
      " Specify a directory for plugins
      """"""""""""""""""""""""""""""
      call plug#begin('~/.config/nvim/plugged')

      Plug 'vim-airline/vim-airline'
      Plug 'Shougo/neomru.vim'
      Plug 'Shougo/unite.vim'
      Plug 'justmao945/vim-clang'
      Plug 'ctrlpvim/ctrlp.vim'
      Plug 'mileszs/ack.vim'
      Plug 'tpope/vim-unimpaired'
      Plug 'junegunn/vim-easy-align'
      Plug 'honza/vim-snippets'
      Plug 'fatih/vim-go'
      Plug 'nsf/gocode'
      Plug 'easymotion/vim-easymotion'
      Plug 'rust-lang/rust.vim'
      Plug 'prabirshrestha/vim-lsp'
      Plug 'prabirshrestha/asyncomplete.vim'
      Plug 'prabirshrestha/asyncomplete-lsp.vim'
      Plug 'mattn/vim-lsp-settings'
      Plug 'mattn/vim-lsp-icons'
      Plug 'hrsh7th/vim-vsnip'
      Plug 'sheerun/vim-polyglot'
      Plug 'https://github.com/adamheins/vim-highlight-match-under-cursor'
      Plug 'rhysd/vim-clang-format'
      Plug 'zefei/vim-wintabs'
      Plug 'zefei/vim-wintabs-powerline'
      Plug 'lambdalisue/fern.vim'

      call plug#end()

      """"""""""""""""""""""""""""""
      " Color scheme
      """"""""""""""""""""""""""""""
      syntax enable
      colorscheme slate
      if has('termguicolors')
        set termguicolors
      endif

      """"""""""""""""""""""""""""""
      " Set parameters
      """"""""""""""""""""""""""""""
      set number
      set title
      set smartindent
      set wildmenu
      set wildmode=list:longest,full
      set tags=./.tags;,.tags;
      set virtualedit=onemore
      set autoindent
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set backspace=2
      set fileformats=unix,dos,mac
      set fileencodings=utf-8,sjis
      set noswapfile
      set hlsearch
      set incsearch
      set ruler
      set cmdheight=2
      set laststatus=2
      set showcmd
      set hidden
      set list
      set listchars=tab:>\ ,extends:<
      set showmatch
      set whichwrap=b,s,h,l,<,>,[,]
      set clipboard&
      set clipboard^=unnamedplus
      set cmdheight=1
      set cursorline

      " Status line info
      set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!='''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
      set statusline+=%{fugitive#statusline()}

      " Undo directory
      set undofile
      if !isdirectory(expand("$HOME/.config/nvim/undodir"))
          call mkdir(expand("$HOME/.config/nvim/undodir"), "p")
      endif
      set undodir=$HOME/.config/nvim/undodir

      packloadall
      silent! helptags ALL

      " Shortcut key to move split windows
      noremap <c-h> <c-w><c-h>
      noremap <c-l> <c-w><c-l>
      noremap <c-j> <c-w><c-j>
      noremap <c-k> <c-w><c-k>

      " Leader key
      let mapleader = "\<space>"

      " Mapping NERDTreeToggle
      noremap <leader>n :NERDTreeToggle<cr>

      " Close buffer without closing window
      command! Bd :bp | :sp | :bn | :bd

      " Close automatically when last window is NERDTree
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") &&
          \ b:NERDTree.isTabTree()) | q | endif

      " Mapping CtrlPBuffer to Ctrl-b
      nnoremap <C-b> :CtrlPBuffer<cr>

      " No highlight with double ESC
      nnoremap <ESC><ESC> :nohl<CR>

      " LSP definition
      nnoremap <expr> <silent> <C-]> execute(':LspDefinition') =~ "not supported" ? "\<C-]>" : ":echo<cr>"

      " Clang options
      let g:clang_c_options = '-std=c11'
      let g:clang_cpp_options = '-std=c++1z -stdlib=libc++ --pedantic-errors'

      " Match paren highlight
      hi MatchParen ctermbg=3

      " Clang-Format
      autocmd FileType c,cpp ClangFormatAutoEnable

      """"""""""""""""""""""""""""""
      " Tab binding
      """"""""""""""""""""""""""""""
      let g:wintabs_autoclose_vim = 1
      map <C-t>h <Plug>(wintabs_previous)
      map <C-t>l <Plug>(wintabs_next)
      map <C-t>c <Plug>(wintabs_close)
      map <C-t>u <Plug>(wintabs_undo)
      map <C-t>o <Plug>(wintabs_only)
      map <C-w>c <Plug>(wintabs_close_window)
      map <C-w>o <Plug>(wintabs_only_window)
      command! Tabc WintabsCloseVimtab
      command! Tabo WintabsOnlyVimtab

      """"""""""""""""""""""""""""""
      " Unite.vim settings
      """"""""""""""""""""""""""""""
      let g:unite_enable_start_insert=1
      noremap <C-P> :Unite buffer<CR>
      noremap <C-N> :Unite -buffer-name=file file<CR>
      noremap <C-Z> :Unite file_mru<CR>
      noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>

      """"""""""""""""""""""""""""""
      " Insert mode status line color
      """"""""""""""""""""""""""""""
      let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

      if has('syntax')
        augroup InsertHook
          autocmd!
          autocmd InsertEnter * call s:StatusLine('Enter')
          autocmd InsertLeave * call s:StatusLine('Leave')
        augroup END
      endif

      let s:slhlcmd = '''
      function! s:StatusLine(mode)
        if a:mode == 'Enter'
          silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
          silent exec g:hi_insert
        else
          highlight clear StatusLine
          silent exec s:slhlcmd
        endif
      endfunction

      function! s:GetHighlight(hi)
        redir => hl
        exec 'highlight '.a:hi
        redir END
        let hl = substitute(hl, '[\r\n]', ''', 'g')
        let hl = substitute(hl, 'xxx', ''', ''')
        return hl
      endfunction

      """"""""""""""""""""""""""""""
      " Auto brackets
      """"""""""""""""""""""""""""""
      inoremap " ""<esc>i
      inoremap ( ()<esc>i
      inoremap { {}<esc>i
      inoremap [ []<esc>i

      " Start at last cursor place
      if has("autocmd")
          autocmd BufReadPost *
          \ if line("'\"") > 0 && line ("'\"") <= line("$") |
          \   exe "normal! g'\"" |
          \ endif
      endif

      """"""""""""""""""""""""""""""
      " Ctags execution
      """"""""""""""""""""""""""""""
      function! s:execute_ctags() abort
        let tag_name = '.tags'
        let tags_path = findfile(tag_name, '.;')
        if tags_path ==# '''
          return
        endif

        let tags_dirpath = fnamemodify(tags_path, ':p:h')
        execute 'silent !cd' tags_dirpath '&& ctags -R -f' tag_name '2> /dev/null &'
      endfunction

      augroup ctags
        autocmd!
        autocmd BufWritePost * call s:execute_ctags()
      augroup END

      """"""""""""""""""""""""""""""
      " Language-specific settings
      """"""""""""""""""""""""""""""
      autocmd FileType c,cpp,cmake setlocal shiftwidth=2
      autocmd BufEnter *.td setlocal shiftwidth=2

      " Rust
      let g:rustfmt_autosave = 1

      """"""""""""""""""""""""""""""
      " LSP settings
      """"""""""""""""""""""""""""""
      let g:lsp_settings = {
      \  'rust-analyzer': {
      \    'initialization_options': {
      \      'cargo': {
      \        'loadOutDirsFromCheck': v:true,
      \      },
      \      'procMacro': {
      \        'enable': v:true,
      \      },
      \      "diagnostics": {
      \        'disabled': [
      \          'unresolved-import',
      \        ],
      \      },
      \    },
      \  },
      \  'clangd': {
      \    'cmd': ['clangd-12']
      \  },
      \  'efm-langserver': {
      \    'disabled': v:false
      \  },
      \  'pylsp-all': {
      \    'workspace_config': {
      \      'pylsp': {
      \        'configurationSources': ['flake8']
      \      }
      \    }
      \  },
      \}

      let g:lsp_diagnostics_echo_cursor = 1
      let g:lsp_diagnostics_virtual_text_enabled = 0
      let g:lsp_diagnostics_highlights_enabled = 0

    '';
  };
}
