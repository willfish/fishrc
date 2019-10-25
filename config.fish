function prepend_to_path -d "Prepend the given dir to PATH if it exists and is not already in it"
  if test -d $argv[1]
    if not contains $argv[1] $PATH
      set -gx PATH "$argv[1]" $PATH
    end
  end
end

prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.local/bin"

set -gx AWS_PROFILE production
set -gx AWS_REGION "eu-west-1"
set -gx EDITOR /usr/bin/nvim
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx LESS "-R"
set -gx fish_greeting ""

source ~/.asdf/asdf.fish
