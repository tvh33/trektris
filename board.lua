board = {}
dim = 32
boardW = 10 * dim
boardH = 18 * dim
yOffset = -192

for i=1,24 do
	board[i] = {}
	for j=1,12 do
		if j == 1 or j == 12 or i == 24 then
			board[i][j] = 9
		else
			board[i][j] = 0
		end
	end
end

function drawBoard()
	love.graphics.rectangle("line", 32, 0, boardW, boardH)
	for i=1,24 do
		for j=1,12 do
			if board[i][j] ~= 9 and board[i][j] ~= 0 then
				local colorq = love.graphics.newQuad((board[i][j]-1)*8, 0, 8, 8, 64, 8)
				love.graphics.drawq(tiles, colorq, ((j-1)*32), (i*32)+yOffset,0,4,4,0,0)
			end
		end
	end
end

function nextStepAllowed(dx, dy, rot)
	local xx = (tetromino.x+dx)/32
	local yy = (tetromino.y+dy)/32
	for i=1,5 do
		for j=1,5 do
			if helper[tetromino.shape][rot][j][i] ~= 0  and board[yy+j][xx+i] ~= 0 then
				return 1
			end
		end
	end
	return 0
end

function lockShape()
	local xx = tetromino.x/32
	local yy = tetromino.y/32
	for i=1,5 do
		for j=1,5 do
			if helper[tetromino.shape][tetromino.rotation][i][j] ~= 0 and i+yy <24 and j+xx > 0 and j+xx < 13  then
				board[i+yy][j+xx] = tetromino.tile
			end
		end
	end
	removeRows()
	resetTetromino()
end

function removeRows()
	local rows = 0
	for i=1,23 do
		local tmp = 0
		for j=2,11 do
			if board[i][j] == 0 then
				tmp = 1
				break
			end
		end
		if tmp == 0 then
			for p=i,2,-1 do
				for q=2,11 do
					board[p][q] = board[p-1][q]
				end
			end
			rows = rows + 1
		end
	end
	calculateScore(rows)
end