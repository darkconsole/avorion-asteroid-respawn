if onServer() then

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- vscode-fold=1

package.path = package.path
.. ";data/scripts/lib/?.lua"
.. ";data/scripts/sector/?.lua"
.. ";data/scripts/?.lua"

require("galaxy")
require("utility")
require("randomext")
-- require("stringutility")
-- require("goods")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local AsteroidRespawn = {
	-- configuration settings --

	Timer  = 43200, -- asteroids respawn time in seconds
	Drift  = 7200,  -- asteroid respawn randomiser, should be smaller than Timer

	-- not config setting dont fuck with these --

	Sector = nil,
	Generator = require("plangenerator"),
	CountFound = 0,
	CountBound = 0
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function
initialize()
	AsteroidRespawn:BindToSector(Sector())
	print(">> script added")
	return
end

function
terminate()
	print(">> script removed (testing to see if removeScript triggers this)")

	-- while this does not get printed, it does seem that the instances of the
	-- script get removed from the asteroids when doing removeScript on the
	-- sector. i base that on the observation that in all my testing none of
	-- my sectors exploded as i constantly did removeScript/addScript over and
	-- over and over.

	return
end

function
AsteroidRespawnCallback_OnDestroyed(EntityID, KillerID)
-- have not quite yet figured out how to make "AsteroidRespawn:OnDestroyed" work
-- for the callback name.

	AsteroidRespawn:OnDestroyed(EntityID,KillerID)
	return
end

function
AsteroidRespawnCallback_OnRespawn(Position)
-- have not quite yet figured out how to make "AsteroidRespawn:OnRespawn" work
-- for the callback name.

	AsteroidRespawn:OnRespawn(Position)
	return
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function
AsteroidRespawn:BindToSector(CurrentSector)
-- attach the destruction events to the sector so we can watch when things
-- go boom.

	-- sector docs claim that onDestroyed and onDamaged callbacks for the
	-- work to know when things within the sector have been attacked but i am
	-- not seeing it work for asteroids at all, so instead we will attach
	-- to all the asteroids worth mining instead...

	local Iter
	local Asteroid
	local Asteroids

	self.Sector = CurrentSector
	self.CountFound = 0
	self.CountBound = 0

	--------
	-- loop over all the mineable asteroids.
	--------

	Asteroids = {self.Sector:getEntitiesByType(EntityType.Asteroid)}

	for Iter,Asteroid in pairs(Asteroids)
	do
		if(Asteroid:getMineableResources() ~= nil)
		then
			self:BindToAsteroid(Asteroid)
			self.CountBound = self.CountBound + 1
		end

		self.CountFound = self.CountFound + 1
	end

	--------
	--------

	print(
		">> respawn script attached to " ..
		self.CountBound .. " of " .. self.CountFound ..
		" asteroids."
	)

	return
end

function
AsteroidRespawn:BindToAsteroid(Asteroid)
-- attach destruction events to the asteroid itself.

	Asteroid:registerCallback(
		"onDestroyed",
		"AsteroidRespawnCallback_OnDestroyed"
	)

	return
end

function
AsteroidRespawn:OnDestroyed(EntityID, KillerID)
-- when the asteroid is destroyed we should delete its instance from the
-- sector and then trigger a new one to spawn.

	local Object = self.Sector:getEntity(EntityID)
	local Delay = (self.Timer + random():getInt((self.Drift * -1),(self.Drift)))

	--------
	-- only work on asteroids
	--------

	if(Object.type ~= EntityType.Asteroid)
	then return end

	--------
	-- spawn a new one in its place after some time passes.
	-- Timer +/- Drift
	--------

	print("asteroid to respawn in " .. Delay .. " seconds.")

	deferredCallback(
		Delay,
		"AsteroidRespawnCallback_OnRespawn",
		Object.position
	)

	--------
	-- then delete the old one
	--------

	print("asteroid destroyed")
	self.Sector:deleteEntity(Object)
	return
end

function
AsteroidRespawn:OnRespawn(Position)
-- respawn the asteroid. called after a random delay.

	local Asteroid = self.Sector:createAsteroid(
		AsteroidRespawn:GetBlockPlan(),
		true,
		Position
	)

	self:BindToAsteroid(Asteroid)
	return
end

function
AsteroidRespawn:GetBlockPlan()
-- generate the plan to build a random asteroid.

	return self.Generator.makeSmallAsteroidPlan(
		random():getInt(
			random():getInt(3,6),
			random():getInt(10,15)
		),
		1,
		self:GetAcceptableMaterial()
	)
end

function
AsteroidRespawn:GetAcceptableMaterial()
-- pick a random material that makes sense for the current sector.

	return Material(getValueFromDistribution(
		Balancing_GetMaterialProbability(self.Sector:getCoordinates())
	))
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

end
