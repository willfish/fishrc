# Programs requiring mfa session

alias mfa="aws-runas"
alias aws="mfa aws"
alias awslogs="mfa awslogs"
alias aws-es-kibana="mfa aws-es-kibana"
alias sam="mfa sam"
alias terragrunt="mfa terragrunt"

# Project switching

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

alias sd="set -gx AWS_PROFILE development"
alias sp="set -gx AWS_PROFILE production"
alias ss="set -gx AWS_PROFILE sandbox"

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
prepend_to_path "/usr/local/opt/inetutils/libexec/gnubin"
prepend_to_path "/usr/local/opt/curl/bin"
prepend_to_path "$HOME/.local/bin"

function da -d "Deploy to all environments"
  mfa
  set -gx BRANCH (branch)
  yes | mfa bin/ecs_deploy_all
  set -e BRANCH
end

function d -d "Deploys each environment specified in the args using bundled capistrano."
  mfa
  set -gx BRANCH (branch)
  for stage in $argv
    mfa bin/ecs_deploy $stage
  end
  set -e BRANCH
end

set -e fish_greeting

function how_long -d "How long have I been at MyDrive?"
  set -l how_long_file "/tmp/how_long"

  test -f $how_long_file

  if test $status -eq 0
    cat $how_long_file
  else
    ~/.scripts/how_long.rb
  end
end

set -gx AWS_PROFILE production
set -gx AWS_REGION "eu-west-1"

set -gx CFLAGS "-O2 -g"
set -gx CFLAGS "$CFLAGS -I/usr/local/opt/openssl/include/openssl"
set -gx CFLAGS "$CFLAGS -I"(xcrun --show-sdk-path)"/usr/include"

set -gx CPPFLAGS "$CPPFLAGS -I/usr/local/opt/openssl/include/openssl"
set -gx CPPFLAGS "$CPPFLAGS -I/usr/local/opt/openblas/include"
set -gx CPPFLAGS "$CPPFLAGS -I/usr/local/opt/readline/include"
set -gx CPPFLAGS "$CPPFLAGS -I/usr/local/opt/zlib/include"

set -gx EDITOR /usr/local/bin/nvim

set -gx ERL_AFLAGS "-kernel shell_history enabled"

set -gx LDFLAGS "$LDFLAGS -L/usr/local/opt/openblas/lib"
set -gx LDFLAGS "$LDFLAGS -L/usr/local/opt/openssl/lib"
set -gx LDFLAGS "$LDFLAGS -L/usr/local/opt/readline/lib"
set -gx LDFLAGS "$LDFLAGS -L/usr/local/opt/zlib/lib"

set -gx LESS "-R"
set -gx MANPATH "/usr/local/opt/inetutils/libexec/gnuman:$MANPATH"
set -gx OPSCODE_USER williamfish1987
set -gx ORGNAME mydrive
set -gx PKG_CONFIG_PATH "$PKG_CONFIG_PATH /usr/local/opt/openblas/lib/pkgconfig"
set -gx PKG_CONFIG_PATH "$PKG_CONFIG_PATH /usr/local/opt/openssl/lib/pkgconfig"
set -gx PKG_CONFIG_PATH "$PKG_CONFIG_PATH /usr/local/opt/readline/lib/pkgconfig"
set -gx PKG_CONFIG_PATH "$PKG_CONFIG_PATH /usr/local/opt/zlib/lib/pkgconfig"
set -gx SLACK_USER_ID U02DF9L76

source /usr/local/opt/asdf/asdf.fish
