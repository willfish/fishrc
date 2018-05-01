alias api="cdr; cd mydriveapi"
alias aws="mydrive-aws-mfa aws"
alias awslogs="mydrive-aws-mfa awslogs"
alias cdb="cd; cd .berkshelf/cookbooks"  
alias cdf="cdr; cd fun"  
alias cdg="cdr; cd mydrive-gems"
alias cdr="cd $HOME/Repositories/mydrive/"
alias cds="cd; cd support/"  
alias cdv="cd; cd .vim_runtime"  
alias cm="cdr; cd cassandra-models"
alias dp="cdr; cd mydrive-data-pipeline-events"
alias grep="grep --colour"
alias heroku="/usr/local/bin/heroku"  
alias inf="cdr; cd mydrive-infrastructure"
alias int="cdr; cd mydrive-integration-testing"
alias jd="cdr; cd jdis"
alias kc="kitchen destroy all; and kitchen converge; and kitchen destroy all"
alias ls="ls -FG"  
alias md="cdr; cd mydrive"
alias pp="cdr; cd phone-platform"
alias rc="bundle exec rails c"
alias revenge="wine $HOME/revenge/ra2md.exe"
alias rs="bundle exec rails s"
alias sd="set -x AWS_PROFILE development"
alias sm="set -x AWS_PROFILE productionmain"
alias sml="rlwrap sml"
alias sp="set -x AWS_PROFILE production"
alias ss="set -x AWS_PROFILE sandbox"
alias t="bundle exec rspec"
alias tf="t --only-failures"
alias vim="nvim"
alias vimdiff="nvim -d"

function prepend_to_path -d "Prepend the given dir to PATH if it exists and is not already in it"
  if test -d $argv[1]
    if not contains $argv[1] $PATH
      set -gx PATH "$argv[1]" $PATH
    end
  end
end

prepend_to_path "$HOME/Repositories/mydrive/mydrive-gems/mydrive-on-demand/bin"
prepend_to_path "/usr/local/opt/cassandra@2.1/bin"
prepend_to_path "/usr/bin"                
prepend_to_path "/usr/local/bin"                
prepend_to_path "/usr/local/sbin"
prepend_to_path "/Applications/Postgres.app/Contents/Versions/9.4/bin"
prepend_to_path "/usr/local/texlive/2014basic/bin/x86_64-darwin/"
prepend_to_path "$HOME/.rbenv/bin"        
prepend_to_path "/opt/chefdk/bin"
prepend_to_path "$HOME/.rbenv/shims"       
prepend_to_path "$HOME/.exenv/bin"
prepend_to_path "$HOME/.pyenv/shims"
prepend_to_path "$HOME/.exenv/shims"

function fish_prompt
  set_color $fish_color_cwd
  echo -n (prompt_pwd)
  say_aws_profile
  set_color normal
  echo " >: "
end

function say_aws_profile
  if test $AWS_PROFILE
    if test $AWS_PROFILE = "sandbox"
      set_color $fish_color_param
    else if test $AWS_PROFILE = "development"
      set_color $fish_color_param
    else if test $AWS_PROFILE = "production"
      set_color $fish_color_error
    else if test $AWS_PROFILE = "productionmain"
      set_color $fish_color_error
    end
  end

  echo -n " $AWS_PROFILE"
end

function deploy -d "Deploys each environment specified in the args using bundled capistrano."
  for stage in $argv
    bundle exec cap $stage deploy
  end
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

function toggle_null_aws_credentials -d "Toggles nulls aws env credentials for sdk compatibility reasons."
  test $AWS_SECRET_ACCESS_KEY

  if test $status -eq 0
    echo "Unsetting null credentials"
    set -e AWS_SECRET_ACCESS_KEY
    set -e AWS_ACCESS_KEY_ID
  else
    echo "Setting null credentials"
    export AWS_SECRET_ACCESS_KEY="FAKE"
    export AWS_ACCESS_KEY_ID="FAKE"
  end
end

function load_secrets -d "Load/reload secrets from the secrets file"
  source ~/.config/fish/secrets.fish
end

function toggle_production_aws_credentials -d "Toggles production aws env credentials."
  load_secrets
  test $AWS_SECRET_ACCESS_KEY

  if test $status -eq 0
    echo "Unsetting credentials"
    set -e AWS_SECRET_ACCESS_KEY
    set -e AWS_ACCESS_KEY_ID
  else
    echo "Setting production credentials"
    set_production_access_key
    set_production_secret_key
  end
end

function how_long -d "How long have I been at MyDrive?"
  set -l how_long_file "/tmp/how_long"

  test -f $how_long_file 

  if test $status -eq 0
    cat $how_long_file 
  else
    ~/.scripts/how_long.rb
  end
end

function cheat.sh
  curl cheat.sh/$argv
end
complete -c cheat.sh -xa "(curl -s cheat.sh/:list)"

set -x AWS_PROFILE production
set -x AWS_REGION eu-west-1
set -x EDITOR /usr/local/bin/vim
set -x ERL_AFLAGS "-kernel shell_history enabled"
set -x LESS "-R"
set -x OPSCODE_USER williamfish1987
set -x ORGNAME mydrive
set -x PYENV_ROOT "$HOME/.pyenv"
set -x fish_greeting (random_science_fiction_quote)

set -gx PYENV_SHELL fish

source "/usr/local/Cellar/pyenv/1.2.3/libexec/../completions/pyenv.fish"
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

set -x CFLAGS "-I"(brew --prefix openssl)"/include"
set -x LDFLAGS "-L"(brew --prefix openssl)"/lib"

exenv rehash 2>/dev/null

function exenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case "shell"
    source (exenv "sh-$command" "$argv"|psub)
  case "*"
    command exenv "$command" "$argv"
  end
end

function fish_mode_prompt
end
