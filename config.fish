# Programs requiring mfa session

alias aws="mfa aws"
alias awslogs="mfa awslogs"
alias aws-es-kibana="mfa aws-es-kibana"
alias sam="mfa sam"
alias terragrunt="mfa terragrunt"

# Convenient project switching

alias cdv="cd; cd .vim_runtime"
alias cdr="cd $HOME/Repositories"
alias md="cdr; cd mydrive"
alias api="cdr; cd mydriveapi"
alias pp="cdr; cd phone-platform"
alias cdg="cdr; cd mydrive-gems"
alias cdt="cdr; cd mydrive-terraform"
alias inf="cdr; cd mydrive-infrastructure"
alias int="cdr; cd mydrive-integration-testing"
alias cdf="cdr; cd fun"

# Convenient utilities

alias branch="git symbolic-ref --short HEAD"
alias grep="grep --colour"
alias ls="ls -FG"

alias rc="bundle exec rails c"
alias rs="bundle exec rails s"

alias sep="sesame open production"

alias sml="rlwrap sml"

alias sd="set -gx AWS_ACCOUNT development"
alias sp="set -gx AWS_ACCOUNT production"
alias ss="set -gx AWS_ACCOUNT sandbox"

alias t="bundle exec rspec"
alias tf="t --only-failures"

alias vim="nvim"
alias vimdiff="nvim -d"

alias fallout="pushd $HOME/.wine/drive_c/GOG\ Games/Fallout\ 2/; wine fallout2.exe; popd"
alias revenge="wine $HOME/revenge/ra2md.exe"

function prepend_to_path -d "Prepend the given dir to PATH if it exists and is not already in it"
  if test -d $argv[1]
    if not contains $argv[1] $PATH
      set -gx PATH "$argv[1]" $PATH
    end
  end
end

prepend_to_path "$HOME/bin"
prepend_to_path "/usr/local/opt/cassandra@2.1/bin"
prepend_to_path "/usr/bin"
prepend_to_path "/usr/local/bin"
prepend_to_path "/usr/local/sbin"
prepend_to_path "/Applications/Postgres.app/Contents/Versions/9.4/bin"
prepend_to_path "/usr/local/texlive/2014basic/bin/x86_64-darwin/"
prepend_to_path "$HOME/.rbenv/bin"
prepend_to_path "/opt/chefdk/bin"
prepend_to_path "$HOME/.rbenv/shims"
prepend_to_path "$HOME/.pyenv/shims"
prepend_to_path "/usr/local/opt/inetutils/libexec/gnubin"
prepend_to_path "/usr/local/opt/curl/bin"
prepend_to_path "$HOME/.local/bin"

function fish_prompt
  set_color $fish_color_cwd
  echo -n (prompt_pwd)
  say_aws_profile
  set_color normal
  echo " >: "
end

function say_aws_profile
  if test $AWS_ACCOUNT
    if test $AWS_ACCOUNT = "production"
      set_color $fish_color_error
    else
      set_color $fish_color_param
    end
  end

  echo -n " $AWS_ACCOUNT"
end

function mfa -d "Inject sts session into environment"
  aws-runas $AWS_ACCOUNT $argv
end

function mydrive_aws_mfa_on
  set -gx AWS_PROFILE $AWS_ACCOUNT
  set -gx AWS_REGION "eu-west-1"
end

function mydrive_aws_mfa_off
  set -e AWS_PROFILE
  set -e AWS_REGION
end

function da -d "Deploy to all environments"
  mydrive_aws_mfa_on
  mydrive-aws-mfa
  set -gx BRANCH (branch)
  yes | bin/ecs_deploy_all
  set -e BRANCH
  mydrive_aws_mfa_off
end

function deploy -d "Deploys each environment specified in the args using bundled capistrano."
  mydrive_aws_mfa_off
  set -gx BRANCH (branch)
  for stage in $argv
    mfa bin/ecs_deploy $stage
  end
  set -e BRANCH
  mydrive_aws_mfa_on
end

set -e quotes
source ~/.config/fish/quotes.fish

function random_quote_api -d "Retrieves a random quote from a predefined list"
  set quote (curl -s "http://api.forismatic.com/api/1.0/?method=getQuote&format=text&lang=en")

  echo -e "\e[32m$quote'\e[0m"
end

function random_science_fiction_quote -d "Retrieves a random quote from a predefined list"
  set random_number (random 1 (count $quotes))
  echo -e "\e[32m$quotes[$random_number]\e[0m"
end

set -gx fish_greeting (random_science_fiction_quote)

function how_long -d "How long have I been at MyDrive?"
  set -l how_long_file "/tmp/how_long"

  test -f $how_long_file

  if test $status -eq 0
    cat $how_long_file
  else
    ~/.scripts/how_long.rb
  end
end

function list_directories
  find . -type d -maxdepth 1 | awk -F'./' '{ print $2}' | sed '/^\s*$/d'
end

set -gx AWS_ACCOUNT production
set -gx CFLAGS "-I(xcrun --show-sdk-path)/usr/include"
set -gx CPPFLAGS "-I/usr/local/opt/openblas/include -I/usr/local/opt/readline/include"
set -gx EDITOR /usr/local/bin/nvim
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx LDFLAGS "-L/usr/local/opt/openblas/lib -L/usr/local/opt/readline/lib"
set -gx LESS "-R"
set -gx MANPATH "/usr/local/opt/inetutils/libexec/gnuman:$MANPATH"
set -gx OPSCODE_USER williamfish1987
set -gx ORGNAME mydrive
set -gx PKG_CONFIG_PATH "/usr/local/opt/openblas/lib/pkgconfig"
set -gx PKG_CONFIG_PATH "/usr/local/opt/readline/lib/pkgconfig"
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx PYENV_SHELL fish
set -gx SLACK_USER_ID U02DF9L76
set -gx CFLAGS "-I"(brew --prefix openssl)"/include"
set -gx LDFLAGS "-L"(brew --prefix openssl)"/lib"

source "/usr/local/Cellar/pyenv/1.2.11/libexec/../completions/pyenv.fish"
function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (pyenv "sh-$command" $argv|psub)
  case "*"
    command pyenv "$command" $argv
  end
end

command pyenv rehash 2>/dev/null

rbenv rehash >/dev/null ^&1

source ~/.asdf/asdf.fish
