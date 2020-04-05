let s:dein_dir = expand('$DATA/dein')

execute 'source' expand('$CONFIG/nvim/rc/mysetting.vim') 

if &runtimepath !~# '/dein.vim'
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

    " Auto Download
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim ' . s:dein_repo_dir
    endif

    execute 'set runtimepath^=' . s:dein_repo_dir
endif

let g:dein#install_max_processes = 16
let g:dein#install_message_type = 'none'

if !dein#load_state(s:dein_dir)
    finish
endif

call dein#begin(s:dein_dir, expand('<sfile>'))
"call dein#begin(s:dein_dir)

let s:toml_dir = expand('$CONFIG/nvim/dein')
let s:plugin_config_dir = expand('$CONFIG/nvim/dein')

call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
call dein#load_toml(s:toml_dir . '/lazy.toml', {'lazy': 1})

if has('python3')
    call dein#load_toml(s:toml_dir . '/python.toml', {'lazy': 1})
endif

call dein#end()
call dein#save_state()

if has('vim_starting') && dein#check_install()
    call dein#install()
endif
