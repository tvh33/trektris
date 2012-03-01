require "helper"
require "tetromino"
require "crew"
require "scoreSystem"

function love.load()
	math.randomseed(os.time())
	frames = 0
	board = {}
	boardHeight = 21
	for i=0,boardHeight do
		board[i] = {}
		for j=0,11 do
		if j == 0 or j == 11 or i == boardHeight then
			board[i][j] = 9
		else
			board[i][j] = 0
		end
	end
    end
	image = love.graphics.newImage( "res/sprites/sprites2.png" )
	image:setFilter("nearest", "nearest")
	rowcount = 0	
	state = 0
	speed = 35
	test = 0
	multiplier = 1.5
	multiplierStore = 1.5
	head = Brik:new({shape = math.random(9), xpos = 128})
	nextTet = Brik:new({shape = math.random(7), xpos = 400, ypos = 30, rotation = 1, probL = 65, probU= 99, prob = math.random(65, 99) })
	stdfont = love.graphics.newFont("res/fonts/visitor1.ttf", 14)
	love.graphics.setFont(stdfont)
	
	yoffset = (boardHeight-17)*-32
	
	
	stars = {}   -- table which will hold our stars
	max_stars = 100   -- how many stars we want
	for i=1, max_stars do   -- generate the coords of our stars
		local x = math.random(5, love.graphics.getWidth()-5)   -- generate a "random" number for the x coord of this star
		local y = math.random(5, love.graphics.getHeight()-5)   -- both coords are limited to the screen size, minus 5 pixels of padding
		stars[i] = {x, y}   -- stick the values into the table
	end
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
	updateDialog(dt)
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
	for i=1, #stars do   -- loop through all of our stars
		love.graphics.point(stars[i][1], stars[i][2])   -- draw each point
	end
	drawBoard()
	drawShape(head)
	drawShape(nextTet)
	drawDialog()
	love.graphics.print(string.format("probability: %s%%", nextTet.prob), 420, 200)
	love.graphics.print(string.format("rows: %s", rowcount), 420, 215)
	love.graphics.print(string.format("Score: %s", score), 420, 230)
	love.graphics.print(string.format("Warp-factor: %s", multiplier), 420, 245)
end

function drawShape(obj)
	for i=0,4 do
		for j=0,4 do
			if helper[obj:getShape()][obj:getRotation()][i+1][j+1] ~= 0  then
				colorq = love.graphics.newQuad((obj:getShape()-1)*8, 0, 8, 8, 64, 8)
				love.graphics.drawq(image, colorq, obj:getX()+(32*j), obj:getY()+(32*i)+32+yoffset,0,4,4,0,0)
			end
		end
	end
end

function drawBoard()
	love.graphics.rectangle("line", 32, 0, 320, 576)
	for i=0,boardHeight do
		for j=0,11 do
			if board[i][j] ~= 9 and board[i][j] ~= 0 then
				colorq = love.graphics.newQuad((board[i][j]-1)*8, 0, 8, 8, 64, 8)
				love.graphics.drawq(image, colorq, (j*32), (i*32)+32+yoffset,0,4,4,0,0)
			end
		end
	end
end

function lockShape()
	xx = head:getX()/32
	yy = head:getY()/32
	for i=0,4 do
		for j=0,4 do
			if helper[head:getShape()][head:getRotation()][i+1][j+1] ~= 0 and i+yy <boardHeight+1 and j+xx > 0 and j+xx < 12  then
				board[i+yy][j+xx] = head:getShape()
				if i+yy <= 2 then
					os.exit()
				end
			end
		end
	end
	removeRows()
	head:setRotation(1)
	tmpp = math.random()
	if (nextTet.prob / 100) >= tmpp then
		head:setShape(nextTet:getShape())
	else
		head:setShape(math.random(9))
	end
	nextTet:setShape(math.random(9))
	nextTet.prob = math.random(nextTet.probL, nextTet.probU)
	head:setY(0)
	head:setX(128)
end

function removeRows()
	local rows = 0
	for i=0,boardHeight-1 do
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
			rows = rows + 1
		end
	end
	calculateScore(rows)
	rowcount = rowcount + rows
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
		head:rotate(1)
   elseif key == "down" then
		multiplierStore = multiplier
		multiplier = 50.0
   elseif key == " " then
		if dialogState == 0 then
			openDialog((dialogType+1) % table.getn(dialogText[1]))
		else
			closeDialog()
		end
   elseif key == "a" then
		multiplier = multiplier - 0.5
   elseif key == "s" then
		multiplier = multiplier + 0.5
   end
end

function love.keyreleased(key)
	if key == "down" then
		multiplier = multiplierStore
	end
end