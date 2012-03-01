systemPower = 100
shieldPower = 50
weaponPower = 50
warpPower = 0
systemClock = 0
lock = 0

function updateSystems(dt)
	systemClock = systemClock+dt
	if systemClock >= 0.5 and shieldPower > 0 then
		shieldPower = shieldPower - 1
		systemClock = 0
	end
	if shieldPower == 0 then
		gameState = 2
		--openDialog(1, "Shields are down.\nSurveying structural integrity.")
	elseif shieldPower < 25 and lock == 0 then
		openDialog(1)
		lock = 1
	end
end

function drawSystemStatus()
	love.graphics.print(string.format("Deflector shields: %s", shieldPower), 420, 250)
	love.graphics.print(string.format("Photon torpedoes: %s", weaponPower), 420, 265)
	love.graphics.print(string.format("Warp core: %s%%", warpPower), 420, 280)
end
