# Vim quick fixes

Quick fixes for Vim first motivated by seeking a shortcut to toggle `colorcolumn`, or what was
briefly known in the Editorconfig world as `max_line_indicator` (which of course should never be
set per-project, only per-user).

*Keys:*
 - Clean up vimrc by moving related groups of config to sub-files and `so group1.vim` / `source
   group2.vim`; load such a file from within Vim with e.g. `:so grp3.vim`.

 - Group functions into importable/ sourceable sub-files (rather than all in `vimrc`).

 - Lazy-load modules/functions by placing files (or symlinks) in `.vim/autoload/` dir and using
   `call file_name#Function_name()<CR>` instead of `source` (alias `so`) function which impacts
   Vim startup time.


## Install and use

    # make the Vim quick-fixes available to your local Vim:
    ln -s ~/dev/q/quick-fixes-ftfw/vim/quick_fixes.vim ~/.vim/autoload/

    # insert shortcuts header into .vim/vimrc :
    echo -e "\n\" quick-fixes-ftfw/vim/quick_fixes.vim keyboard shortcuts:" >> ~/.vim/vimrc

    # assign <F1> keyboard shortcut to Toggle_max_line_indicator():
    echo -e "\nnnoremap <F1> :call quick_fixes#Toggle_max_line_indicator()<CR>" >> ~/.vim/vimrc


## Notes/ things learnted

 - Vim files containing functions/ subroutines for sourcing, to be compatible with Vim
   `autoload/` facility, must use only underscores in the file name, not hyphen.

 - To set an option with the value contained in a variable, cannot use normal `set` function but
   must use something like `let &colorcolumn = w:max_line_indicator_prev` ; note the use of
   `let`, note the `&` "optiona reference" syntax to the left of the `=`, and whatever variable
   has the goods to the right of `=` (as expected).

