# -*- coding: utf-8 -*-
require 'rake/clean'

HOME = ENV["HOME"]
PWD = File.dirname(__FILE__)
OS = `uname`

def symlink_ file, dest
  symlink file, dest if not File.exist?(dest)
end

def same_name_symlinks root, files
  files.each do |file|
    symlink_ File.join(root, file), File.join(HOME, "." + file)
  end
end

cleans = [
          ".zshrc",
          ".tmux.conf",
          ".gitconfig",
          ".gitignore.global",
          ".gemrc",
         ]

CLEAN.concat(cleans.map{|c| File.join(HOME,c)})

task :default => :setup
task :setup => [
              "git:link",
              "tmux:link",
              "zsh:link",
              "zsh:tools",
              "nvim:link",
              "peco:link",
              "etc:link",
              "starship:link"]

namespace :zsh do
  desc "Create symbolic link to HOME/.zshrc"
  task :link do

    # If `.zshrc` is already exist, backup it
    if File.exist?(File.join(HOME, ".zshrc")) && !File.symlink?(File.join(HOME, ".zshrc"))
      mv File.join(HOME, ".zshrc"), File.join(HOME, ".zshrc.org")
    end

    symlink_ File.join(PWD, "zsh/zshrc"), File.join(HOME, ".zshrc")      
  end

  task :tools do
    sh "mkdir ~/.zsh"
    sh "git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions"
  end
end

namespace :git do
  desc "Create symbolic link to HOME"
  task :link do    
    same_name_symlinks File.join(PWD, "git"), ["gitconfig", "gitignore.global"]
  end
end

namespace :tmux do  
  desc "Create symblic link to HOME"
  task :link do
    same_name_symlinks File.join(PWD, "tmux"), ["tmux.conf"]
  end
end

namespace :nvim do
  desc "Create symblic link to HOME/.config"
  task :link do
    sh "mkdir -p $HOME/.config/nvim/"
    symlink_ File.join(PWD, "vim/vimrc"), File.join(HOME, ".config/nvim/init.vim")
  end
end

namespace :peco do
  desc "Create symbolic link to HOME/.config"
  task :link do
    sh "mkdir -p $HOME/.config/peco/" 
    symlink_ File.join(PWD, "peco/config.json"), File.join(HOME, ".config/peco/config.json")
  end
end

namespace :etc do
  task :link do
    etcs  =  Dir.glob("etc" +  "/*").map{|path| File.basename(path)}
    same_name_symlinks File.join(PWD, "etc"), etcs
  end
end

namespace :starship do
  desc "Create symbolic link to HOME/.config"
  task :link do
    sh 'sh -c "$(curl -fsSL https://starship.rs/install.sh)"'
    symlink_ File.join(PWD, "zsh/starship.toml"), File.join(HOME, ".config/starship.toml")
  end
end
