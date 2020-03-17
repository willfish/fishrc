function prepend_to_path -d "Prepend the given dir to PATH if it exists and is not already in it"
  if test -d $argv[1]
    if not contains $argv[1] $PATH
      set -gx PATH "$argv[1]" $PATH
    end
  end
end

prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.local/bin"
# prepend_to_path "/snap/bin"

set -gx EDITOR /home/william/.asdf/shims/nvim
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx LESS "-R"
set -gx ASDF_RUBY_BUILD_VERSION "master"
set -gx fish_greeting ""
set -gx SAM_CLI_TELEMETRY 0

# Linux Brew

set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";
set -g fish_user_paths "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin" $fish_user_paths;
set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/home/linuxbrew/.linuxbrew/share/man" $MANPATH;
set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH;

function pomegranate_env -d "Load environment credentials for pomegranate"
  clear_env
  set env_file ~/.aws_pomegranate.fish
  source $env_file
end


function personal_env -d "Load environment credentials for personal"
  clear_env
  set -l env_file ~/.aws_personal.fish
  source $env_file
end

function clear_env -d "Clears all AWS environment variables"
  set -e AWS_ACCESS_KEY_ID
  set -e AWS_SECRET_ACCESS_KEY
end

function harsh -d "Danger find pids relating to program and harsh kill them"
  for pid in (ps uax | grep $argv[1] | grep -v grep | awk '{print $2}')
    sudo kill -9 $pid
  end
end

source ~/.asdf/asdf.fish
