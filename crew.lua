crew = love.graphics.newImage("characters.png")
crew:setFilter("nearest", "nearest")

dialogText = {{"Lt. Cmd. Data", "Lt. Worf"},{'"Aft shields are down to 40 %.\nCompensating."', '"Phasers locked on target,\nready on your command!"'}}

dialogState = 0
dialogType = 0
dialogX = 390
dialogHiddenY = 610
dialogTargetY = 440
dialogY = dialogHiddenY

function openDialog(t)
	dialogType = t
	dialogState = 1
end

function updateDialog(dt)
	if (dialogState ~= 0) then
		if (dialogState == 1) then
			if (dialogY > dialogTargetY) then
				dialogY = dialogY - 1500*dt
			else
				dialogState = 2
			end
		elseif (dialogState == 3) then
			if (dialogY < dialogHiddenY) then
				dialogY = dialogY + 1500*dt
			else
				dialogState = 0
			end
		end
	end
end

function drawDialog()
	if (dialogState ~= 0) then
		dialogq = love.graphics.newQuad(dialogType*32, 0, 32, 48, 64, 48)
		love.graphics.drawq(crew, dialogq, dialogX, dialogY, 0, 3, 3, 0,0)
		love.graphics.print(dialogText[1][dialogType+1], dialogX+110, dialogY+70 )
		love.graphics.print(dialogText[2][dialogType+1], dialogX+110, dialogY+90 )
	end
end

function closeDialog()
	dialogState = 3
end