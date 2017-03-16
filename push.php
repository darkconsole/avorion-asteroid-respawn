<?php

// this script will copy the files to our server via my remote ssh mount.

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

define('ProjectRoot','..');
define('StockDir', '/avorion-0.10.5/data/scripts');
define('ModDir', '/avorion-asteroid-respawn/data/scripts');
define('PatchDir', '/avorion-asteroid-respawn/patches');
define('RemoteDir','z:\home\avorion\steamcmd\avorion\data\scripts');

define('Files',[
	'/dcc-asteroid-respawn.lua' => '/patch-dcc-asteroid-respawn.diff'
]);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function
Pathify(String $Filepath):
String {
/*//
generate proper file paths for the os given that we are writing the code for
forward slashes in mind. seems to be needed for some windows commands.
//*/

	$Filepath = str_replace('%VERSION%','Version',$Filepath);

	return str_replace('/',DIRECTORY_SEPARATOR,$Filepath);
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

$File;
$Patch;
$Command;

foreach(Files as $File => $Patch) {
	$Command = sprintf(
		'xcopy /R /Y %s %s',
		escapeshellarg(Pathify(ProjectRoot.ModDir.$File)),
		escapeshellarg(Pathify(RemoteDir.$File))
	);

	echo $Command, PHP_EOL;
	system($Command);
}
