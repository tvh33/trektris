require "helper"

function love.load()
	math.randomseed(os.time())
	frames = 0
	mt = {}          -- create the matrix
	for i=0,17 do
		mt[i] = {}     -- create a new row
		for j=0,11 do
			if j == 0 or j == 11 or i == 17 then
				mt[i][j] = 8
			else
				mt[i][j] = 0
			end
		end
	end
	ypos = 0
	xpos = 128
	image = love.graphics.newImage( "sprites.png" )
	image:setFilter("nearest", "nearest")
	rowcount = 0
	shapetype = math.random(7)
	rotation = 1
	state = 0
	speed = 35
	test = 0
	multiplier = 1.5
end

function love.update(dt)
	frames = frames + 1
	test = test + multiplier*dt
	if test > 1.0 then
		if nextStepAllowed(0,32,rotation) == 0 then
			ypos = ypos + 32
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
	yy = (ypos+dy)/32
	xx = (xpos+dx)/32
	for i=0,4 do
		for j=0,4 do
			if helper[shapetype][rot][j+1][i+1] ~= 0  and mt[yy+j][xx+i] ~= 0 then
				return 1
			end
		end
	end
	return 0
end

function love.draw()
	drawBoard()
	drawShape()
	love.graphics.print(rowcount, 450, 50)
end

function drawShape()
	for i=0,4 do
		for j=0,4 do
			if helper[shapetype][rotation][i+1][j+1] ~= 0  then
				colorq = love.graphics.newQuad((shapetype-1)*8, 0, 8, 8, 56, 8)
				love.graphics.drawq(image, colorq, xpos+(32*j), ypos+(32*i)+32,0,4,4,0,0)
			end
		end
	end
end

function drawBoard()
	love.graphics.rectangle("line", 32, 32, 320, 544)
	for i=0,17 do
		for j=0,11 do
			if mt[i][j] ~= 8 and mt[i][j] ~= 0 then
				colorq = love.graphics.newQuad((mt[i][j]-1)*8, 0, 8, 8, 56, 8)
				love.graphics.drawq(image, colorq, (j*32), (i*32)+32,0,4,4,0,0)
			end
		end
	end
end

function lockShape()
	xx = xpos/32
	yy = ypos/32
	for i=0,4 do
		for j=0,4 do
			if helper[shapetype][rotation][i+1][j+1] ~= 0 and i+yy <18 and j+xx > 0 and j+xx < 12  then
				mt[i+yy][j+xx] = shapetype
			end
		end
	end
	removeRows()
	rotation = 1
	shapetype = math.random(7)
	ypos = 0
	xpos = 128
end

function removeRows()
	for i=0,16 do
		tmp = 0
		for j=1,10 do
			if mt[i][j] == 0 then
				tmp = 1
				break
			end
		end
		if tmp == 0 then
			for p=i,1,-1 do
				for q=1,10 do
					mt[p][q] = mt[p-1][q]
				end
			end
			rowcount = rowcount + 1
		end
	end
end

function love.keypressed(key)
   if key == "left" then
		if nextStepAllowed(-32,0,rotation) == 0 then
			xpos = xpos - 32
		end
   elseif key == "right" then
		if nextStepAllowed(32,0,rotation) == 0 then
			xpos = xpos + 32
		end
   elseif key == "up" then
		newrotation = (rotation % 4) + 1
		if nextStepAllowed(0,0,newrotation) == 0 then
			rotation = newrotation
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
