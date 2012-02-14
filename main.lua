require "helper"
require "tetromino"

function love.load()
	math.randomseed(os.time())
	frames = 0
	board = {}
	for i=0,17 do
		board[i] = {}
		for j=0,11 do
		if j == 0 or j == 11 or i == 17 then
			board[i][j] = 8
		else
			board[i][j] = 0
		end
	end
    end
	image = love.graphics.newImage( "sprites.png" )
	image:setFilter("nearest", "nearest")
	rowcount = 0
	
	rotation = 1
	state = 0
	speed = 35
	test = 0
	multiplier = 1.5
	head = Brik:new({shape = math.random(7), xpos = 128})
	nextTet = Brik:new({shape = math.random(7), xpos = 400, ypos = 30, rotation = 1, probL = 80, probU= 99, prob = math.random(80, 99) })
end

function love.update(dt)
	frames = frames + 1
	test = test + multiplier*dt
	if test > 1.0 then
		if nextStepAllowed(0,32,head:getRotation()) == 0 then
			head:incrY(32)
		elseif state == 1 then
			lockShape()
			state = 0
		else
			state = 1
		end
		test = 0
	end
end

function nextStepAllowed(dx, dy, rot)
	yy = (head:getY()+dy)/32
	xx = (head:getX()+dx)/32
	for i=0,4 do
		for j=0,4 do
			if helper[head:getShape()][rot][j+1][i+1] ~= 0  and board[yy+j][xx+i] ~= 0 then
				return 1
			end
		end
	end
	return 0
end

function love.draw()
	drawBoard()
	drawShape(head)
	drawShape(nextTet, 2)
	love.graphics.print(string.format("probability: %s%%", nextTet.prob), 420, 150)
	love.graphics.print(string.format("rows: %s", rowcount), 420, 165)
end

function drawShape(obj, s)
	scale = s or 4
	dim = 8*scale
	for i=0,4 do
		for j=0,4 do
			if helper[obj:getShape()][obj:getRotation()][i+1][j+1] ~= 0  then
				colorq = love.graphics.newQuad((obj:getShape()-1)*8, 0, 8, 8, 56, 8)
				love.graphics.drawq(image, colorq, obj:getX()+(dim*j), obj:getY()+(dim*i)+32,0,scale,scale,0,0)
			end
		end
	end
end

function drawBoard()
	love.graphics.rectangle("line", 32, 32, 320, 544)
	for i=0,17 do
		for j=0,11 do
			if board[i][j] ~= 8 and board[i][j] ~= 0 then
				colorq = love.graphics.newQuad((board[i][j]-1)*8, 0, 8, 8, 56, 8)
				love.graphics.drawq(image, colorq, (j*32), (i*32)+32,0,4,4,0,0)
			end
		end
	end
end

function lockShape()
	xx = head:getX()/32
	yy = head:getY()/32
	for i=0,4 do
		for j=0,4 do
			if helper[head:getShape()][head:getRotation()][i+1][j+1] ~= 0 and i+yy <18 and j+xx > 0 and j+xx < 12  then
				board[i+yy][j+xx] = head:getShape()
			end
		end
	end
	removeRows()
	head:setRotation(1)
	tmpp = math.random()
	if (nextTet.prob / 100) >= tmpp then
		head:setShape(nextTet:getShape())
	else
		head:setShape(math.random(7))
	end
	nextTet:setShape(math.random(7))
	nextTet.prob = math.random(nextTet.probL, nextTet.probU)
	head:setY(0)
	head:setX(128)
end

function removeRows()
	for i=0,16 do
		tmp = 0
		for j=1,10 do
			if board[i][j] == 0 then
				tmp = 1
				break
			end
		end
		if tmp == 0 then
			for p=i,1,-1 do
				for q=1,10 do
					board[p][q] = board[p-1][q]
				end
			end
			rowcount = rowcount + 1
		end
	end
end

function love.keypressed(key)
   if key == "left" then
		if nextStepAllowed(-32,0,head:getRotation()) == 0 then
			head:incrX(-32)
		end
   elseif key == "right" then
		if nextStepAllowed(32,0,head:getRotation()) == 0 then
			head:incrX(32)
		end
   elseif key == "up" then
		newrotation = (head:getRotation() % 4) + 1
		if nextStepAllowed(0,0,newrotation) == 0 then
			head:setRotation(newrotation)
		end
   elseif key == "down" then
		multiplier = 50.0
   end
end

function love.keyreleased(key)
	if key == "down" then
		multiplier = 1.5
	end
end