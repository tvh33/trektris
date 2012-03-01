tetromino = {x = 128, y = 0, rotation = 1, shape = 1, tile = 1}

function drawTetromino()
	for i=1,5 do
		for j=1,5 do
			if helper[tetromino.shape][tetromino.rotation][i][j] ~= 0  then
				local colorq = love.graphics.newQuad((tetromino.tile-1)*8, 0, 8, 8, 64, 8)
				love.graphics.drawq(tiles, colorq, tetromino.x+(32*(j-1)), tetromino.y+(32*i)+yOffset,0,4,4,0,0)
			end
		end
	end
end

function resetTetromino()
	tetromino.rotation = 1
	tetromino.x = 128
	tetromino.y = 0
	decideNewTetromino()
end

function decideNewTetromino()
	local newShape = 0
	if gameState == 1 then
		newShape = math.random(1,7)
	elseif gameState == 2 then
		newShape = math.random(1,9)
	end
	tetromino.shape = newShape
	if newShape > 8 then
		tetromino.tile = 8
	else
		tetromino.tile = newShape
	end
end

function rotateTetromino(dr)
	local newrotation = (tetromino.rotation % 4) + dr
	if nextStepAllowed(0,0,newrotation) == 0 then
		tetromino.rotation = newrotation
	end
end