function cf
	if test "$argv[1]" = "target"
    clear_apps
    clear_services
    /home/william/.asdf/shims/cf $argv
  else
    /home/william/.asdf/shims/cf $argv
  end
end
