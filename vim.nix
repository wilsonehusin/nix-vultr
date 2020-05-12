with import <nixpkgs> {};

vim_configurable.customize {
  name = "vim";
  vimrcConfig.customRC = ''
    set t_Co=256
    color wombat256mod
    syntax enable
    set expandtab
    set smarttab
    set nocindent
    set number
    set showcmd
    set cursorline
    set wildmenu
    set showmatch
    set incsearch
    set hlsearch
    set ignorecase
    set smartcase
    set filetype=unix
    set autoread
    set backspace=indent,eol,start

    nnoremap j gj
    nnoremap k gk

    set mouse=a
    if has("mouse_sgr")
      set ttymouse=sgr
    else
      set ttymouse=xterm2
    end

    silent !mkdir $HOME/.vim > /dev/null 2>&1
    silent !mkdir $HOME/.vim/backups > /dev/null 2>&1
    silent !mkdir $HOME/.vim/undo > /dev/null 2>&1
    silent !mkdir $HOME/.vim/swaps > /dev/null 2>&1

    " Swapfile and enable backups
    set backup
    set dir=$HOME/.vim/swaps//
    set backupdir=$HOME/.vim/backups//
    
    " Enable undo storage
    set undofile
    set undodir=$HOME/.vim/undo//
    set undolevels=5000
    set undoreload=50000
    let myvar = "set backupext=_". strftime("--%y%m%d--%Hh%M")
    execute myvar
    
    " NERDTree
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    
    " ALE
    let g:ale_linters = {'ruby': ['standardrb']}
    let g:ale_fixers = {'ruby': ['standardrb']}
    let g:ale_fix_on_save = 1
  '';
  vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
  vimrcConfig.vam.pluginDictionaries = [
    { names = [
      "ale"
      "nerdtree"
      "fzf-vim"
      "wombat256-vim"
    ]; }
  ];
}
