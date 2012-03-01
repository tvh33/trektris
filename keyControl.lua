function love.keypressed(key)
	if key == "left" then
		if nextStepAllowed(-32,0,tetromino.rotation) == 0 then
			tetromino.x = tetromino.x - 32
		end
	elseif key == "right" then
		if nextStepAllowed(32,0,tetromino.rotation) == 0 then
			tetromino.x = tetromino.x + 32
		end
	elseif key == "up" then
		rotateTetromino(1)
	elseif key == "down" then
		warp = 50.0
	elseif key == " " then
		if dialogState == 0 then
			openDialog((dialogType+1) % #dialogText[1])
		else
			closeDialog()
		end
	elseif key == "s" then
		openDialog(1)
	end
end

function love.keyreleased(key)
	if key == "down" then
		warp = 1.5
	end
end