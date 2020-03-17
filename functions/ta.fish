# Defined in - @ line 0
function ta --description 'alias ta=tmux attach'
  tmux new-session -A -s main
end
