require "starfield"
require "tetromino"
require "helper"
require "crew"
require "scoreSystem"
require "board"
require "keyControl"
require "shipComputer"

function love.load()
	math.randomseed(os.time())
	tiles = love.graphics.newImage( "res/sprites/sprites2.png" )
	tiles:setFilter("nearest", "nearest")
	gameState = 1	--1 normal, 2 shields down
	warp = 1.5
	thres = 0
	state = 0
end

function love.update(dt)
	updateStarfield(dt)
	thres = thres + warp*dt
	if thres > 1.0 then
		if  nextStepAllowed(0,32,tetromino.rotation) == 0 then
			tetromino.y = tetromino.y + 32
		elseif state == 1 then
			lockShape()
			state = 0
		else
			state = 1
		end
		thres = 0
	end
	updateDialog(dt)
	updateSystems(dt)
end

function love.draw()
	drawStarfield()
	drawBoard()
	drawTetromino()
	drawScore()
	drawSystemStatus()
	drawDialog()
end