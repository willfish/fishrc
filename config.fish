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
set -gx EDITOR "$HOME/.asdf/shims/nvim"
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx LESS "-R"
set -gx fish_greeting ""
set -gx ASDF_RUBY_BUILD_VERSION "master"

alias vim="nvim"

alias cdv="cd ~/.vim_runtime"
alias cdr="cd ~/Repositories"
alias cdf="cdr; cd fun"

alias t="bundle exec rspec"
alias rs="bundle exec rails server"
alias rc="bundle exec rails console"
alias t="bundle exec rspec"
alias g="git"

function harsh -d "Danger find pids relating to program and harsh kill them"
  for pid in (ps uax | grep $argv[1] | grep -v grep | awk '{print $2}')
    kill -9 $pid
  end
end

if [ (uname) == "Darwin" ]
  source /usr/local/opt/asdf/asdf.fish
  prepend_to_path "/usr/local/opt/openvpn/sbin"
else
  source ~/.asdf/asdf.fish
end

function install_notes
  if not test -e "$HOME/Notes/"
    git clone git@github.com:willfish/notes.git "$HOME/Notes"
  end
end

function today -d "Open today's notes"
  set -l todays_date (date +%F)
  set -l notes_directory "$HOME/Notes/$todays_date"
  set -l note_file "$notes_directory/today.md"
  set -l template_file "$HOME/Notes/templates/today.md"

  install_notes

  if not test -e $note_file
    mkdir -p $notes_directory
    cp $template_file $note_file
    sed -i '' "s/TodaysDate/$todays_date/" $note_file
  end

  pushd $notes_directory
  vim $note_file
  popd $notes_directory
end

function standup -d "Open today's standup notes"
  set -l todays_date (date +%F)
  set -l notes_directory "$HOME/Notes/$todays_date"
  set -l note_file "$notes_directory/standup.md"
  set -l template_file "$HOME/Notes/templates/standup.md"

  install_notes

  if not test -e $note_file
    mkdir -p $notes_directory
    cp $template_file $note_file
    sed -i '' "s/TodaysDate/$todays_date/" $note_file
  end

  pushd $notes_directory
  vim $note_file
  popd $notes_directory
end
