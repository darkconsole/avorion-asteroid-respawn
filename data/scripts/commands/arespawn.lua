
function execute(sender, commandName, action, ...)

	if(OnServer())
	then
		Sector():addScript("dcc-asteroid-respawn")
	end

	return 0, "", ""
end
