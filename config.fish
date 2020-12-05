function prepend_to_path
  if test -d $argv[1]
    if not contains $argv[1] $PATH
      set -gx PATH "$argv[1]" $PATH
    end
  end
end

function prepend_to_info
  if test -d $argv[1]
    if not contains $argv[1] $PATH
      set -gx INFOPATH "$argv[1]" $PATH
    end
  end
end

function prepend_to_man
  if test -d $argv[1]
    if not contains $argv[1] $PATH
      set -gx MANPATH "$argv[1]" $PATH
    end
  end
end

prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.local/bin"
prepend_to_path "/usr/local/bin"

set -gx ASDF_RUBY_BUILD_VERSION "master"
set -gx EDITOR "$HOME/.asdf/shims/nvim"
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx LESS "-R"
set -gx fish_greeting ""
set -gx SAM_CLI_TELEMETRY 0
set -gx CHANGELOG_GITHUB_TOKEN "6147ea4fb715614e605df3392e9d94d7e3db05bd"
set -gx MANPAGER 'nvim +Man!'

if [ (uname) = "Darwin" ]
else
  # Linux Brew
  set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
  set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
  set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";

  prepend_to_man "/home/linuxbrew/.linuxbrew/share/man" 
  prepend_to_info "/home/linuxbrew/.linuxbrew/share/info" 
  prepend_to_info "/usr/share/terminfo"

  set -gx fish_user_paths "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin" $fish_user_paths;
  set -gx theme_nerd_fonts yes
end

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

    if [ (uname) = "Darwin" ]
      sed -i '' "s/TodaysDate/$todays_date/" $note_file
    else
      sed -i "s/TodaysDate/$todays_date/" $note_file
    end
  end

  pushd $notes_directory
  vim $note_file
  popd
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

    if [ (uname) = "Darwin" ]
      sed -i '' "s/TodaysDate/$todays_date/" $note_file
    else
      sed -i "s/TodaysDate/$todays_date/" $note_file
    end
  end

  pushd $notes_directory
  vim $note_file
  popd
end

if [ (uname) = "Darwin" ]
  source /usr/local/opt/asdf/asdf.fish
  prepend_to_path "/usr/local/opt/openvpn/sbin"
else
  source ~/.asdf/asdf.fish
end

if not pgrep -f ssh-agent > /dev/null
  eval (ssh-agent -c)
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  ssh-add
end
