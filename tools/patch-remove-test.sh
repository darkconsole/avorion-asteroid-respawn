#/bin/sh

cat ../avorion-asteroid-respawn/patches/* | patch -p2 -R --dry-run
