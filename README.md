# Shell helpers

Utilities for Bash, e.g. commands and aliases I like to use or have written

May need to comment / uncomment platform specific config, i.e. for MacOS.

Other (old) configs saved as gists need to be consolidated and updated: https://gist.github.com/jshields


## Setup:
Assuming repo is cloned at `~/workspace/jshields`.
(Depending on which shell is used, setup the config where it can be sourced by default)
```
ln -s ~/workspace/jshields/shell_helpers/_.bashrc ~/.bashrc
ln -s ~/workspace/jshields/shell_helpers/_.zshrc ~/.zshrc
```

Mac OS X
```
ln -s ~/workspace/jshields/shell_helpers/_.bash_profile ~/.bash_profile

ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl ~/bin/subl
```

## Other setup steps

VS Code `code` command setup:
https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line

Git Aliases:
https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases

Install `ag`:
https://github.com/ggreer/the_silver_searcher

SSH:
`cp _sshconfig ~/.ssh/config`, make changes as needed based on what keys are present on the machine
