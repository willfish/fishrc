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

prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.local/bin"
prepend_to_path "/usr/local/bin"

set -gx ASDF_RUBY_BUILD_VERSION "master"
set -gx EDITOR "/usr/local/bin/nvim"
set -gx VISUAL "/usr/local/bin/nvim"
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx LESS "-R"
set -gx GIT_PAGER "less"
set -gx fish_greeting ""
set -gx SAM_CLI_TELEMETRY 0
set -gx MANPAGER 'nvim +Man!'
set -gx PKG_CONFIG_PATH /usr/lib/x86_64-linux-gnu/pkgconfig
set -gx VK_ICD_FILENAMES /usr/share/vulkan/icd.d/nvidia_icd.json # https://vulkan.lunarg.com/issue/home?limit=10;q=;mine=false;org=false;khronos=false;lunarg=false;indie=false;status=new,open - debugging issue with loading vkcube

if [ (uname) = "Darwin" ]
else
  # Linux Brew
  set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
  set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
  set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";

  prepend_to_info "/home/linuxbrew/.linuxbrew/share/info" 
  prepend_to_info "/usr/share/terminfo"

  set -gx fish_user_paths "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin" $fish_user_paths;
  set -gx theme_nerd_fonts yes
end

function hmrc_env
  clear_env
  set -gx AWS_REGION eu-west-2
  set -gx AWS_PROFILE hmrc
end

function pomegranate_env
  clear_env
  set -gx AWS_REGION eu-west-2
  set -gx AWS_PROFILE pomegranate
end

function personal_env
  clear_env
  set -gx AWS_REGION eu-west-2
  set -gx AWS_PROFILE personal
end

function clear_env -d "Clears all AWS environment variables"
  set -e AWS_REGION
  set -e AWS_PROFILE
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

# date -d "+1 day" --iso-8601

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

source ~/.asdf/asdf.fish

if not pgrep -f ssh-agent > /dev/null
  eval (ssh-agent -c)
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
  ssh-add
end

function spaces
  cf spaces | grep -v name | grep -v '^$' | grep -v 'Getting'
end

function apps
  set -l apps_file ~/.config/cf/apps.txt

  if not test -e $apps_file
    cf apps | grep -v name | grep -v Getting | grep -v '^$' | awk '{ print $1 }' > $apps_file
  end
  cat $apps_file
end

function services
  set -l services_file ~/.config/cf/services.txt

  if not test -e $services_file
    cf services | grep -v name | grep -v Getting | grep -v '^$' | awk '{ print $1 }' > $services_file
  end

  cat $services_file
end

function clear_apps
  set -l apps_file ~/.config/cf/apps.txt

  if test -e $apps_file
    rm $apps_file
  end
end

function clear_services
  set -l services_file ~/.config/cf/services.txt

  if test -e $services_file
    rm $services_file
  end
end

function cf_ssh
  set -l app (apps | fzf)

  cf ssh $app
end

function cf_rb
  set -l app (apps | grep -e frontend -e backend -e admin -e duty | fzf)

  cf ssh $app -t -c "/tmp/lifecycle/launcher /home/vcap/app 'rails c' ''"
end

function cf_flush
  set -l service (services | grep redis | fzf)

  cf conduit $service -- redis-cli FLUSHALL
end

function cf_info
  set -l service (services | grep redis | fzf)

  cf conduit $service -- redis-cli info
end

function cf_psql
  set -l service (services | grep postgres | fzf)

  cf conduit $service -- psql
end

function backup_manifests
  cdr; cd hmrc/manifests-backup

  for space in (cat spaces)
    cf target -s $space
    mkdir -p $space/

    pushd $space

    apps > $space/apps

    for app in (cat apps)
      cf create-app-manifest $app
    end

    popd
  end
end

function two_monitors
  xrandr --output DP-1-2 --auto --primary --rotate normal --output eDP-1-1 --preferred --rotate normal --below DP-1-2
end

function cdn_invalidate_production
  aws cloudfront create-invalidation --distribution-id EFNZFAYYYB7R4 --paths "/" "/*"
end

function cdn_invalidate_development
  aws cloudfront create-invalidation --distribution-id E3CTPYC9CP3SAZ --paths "/" "/*"
end

function cdn_invalidate_staging
  aws cloudfront create-invalidation --distribution-id E1IATQ3JO4BWV6 --paths "/" "/*"
end
