# Avorion Asteroid Respawner

Respawns asteroids after mining. By default they respawn every twelve hours give
or take two for randomness.

So you've been jumping around for days and you finally found a sector you wish
to call home. The only problem is you know in a few days time you will have
mined out the entire 50x50 area around your home, forcing you to leave. For an
open ended game its pretty easy to mine the galaxy out and have no way to
progress, especally with multiple players on the server.

It is not automatically activated which is currently on purpose. To enable a
sector to have respawning you must attach this script to it before you mine
it out. This will require you have `/run` permissions on the server, or ask a
server admin/moderator to jump into the sector and activate it for you.

It is being researched the best way to make this magically happen. Until then,
see the Activation section for details.

# Installation

~~This mod only needs to be on the server.~~

There is a "bug" (maybe) where if the client does not have a script, the game
will get stuck at the `Loading...` screen for eternity. Therefore currently as
it is, both the client and server need to have it installed. This script has
ZERO effect on the client, the entire block of code is wrapped with onServer()
but if the file is just not found then the game gets stuck. So, yeah. For all
that matters the client could have a blank file there and it would not matter,
as long as it exists. But if you install this like normal into your game then it
will work in single player too.

* Copy `data\scripts\dcc-asteroid-respawn.lua` into your `data\scripts`

# Configuration

In the `data\scripts\dcc-asteroid-respawn.lua` script there is a config section
where you can tweak the mod.

## Timer
Integer, default 43200 (12hr). This sets how long it takes asteroids to respawn
in seconds. 900 = 15min. 3600 = 1hr. 86400 = 1d.

## Drift
Integer, default 7200 (2hr). This sets the random jitter applied the the
respawn timer. Using the default settings as an example, that means that the
asteroid will respawn between 10 to 14 hours of being mined.

# Activation

When you find an asteroid field you would like to enable respawning for, BEFORE
you mine it, activate the respawner for this sector.

`/run Sector():addScript("dcc-asteroid-respawn")`

And you should be good to go. If you pull down the console (the ' key) you
should see a message like "found 50 of 1593 asteroids" which means in this
sector there are 50 of them that are worth mining, and will now automatically
respawn later.

You can activate this script on a sector that has already been mined a bit, but
only the asteroids that are still there will respawn, it will not magically make
the ones that are already missing come back.
