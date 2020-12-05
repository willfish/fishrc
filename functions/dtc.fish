# Defined in /home/william/.config/fish/functions/dtc.fish @ line 2
function dtc
	set -l target_directory .terragrunt-cache/

  if test -d $target_directory
    echo "Clearing terragrunt cache $target_directory"
    rm -rf $target_directory
    return 0
  else
    echo "No cache found"
    return 0
  end
end
