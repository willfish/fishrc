# Defined in - @ line 1
function rc --description 'alias rc=bundle exec rails c'
	bundle exec rails c $argv;
end
