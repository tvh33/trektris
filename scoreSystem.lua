score = 0
combo = 0
rowCount = 0

--Tilføj noget der tager højde for # rækker fjernet inden for tidsinterval

function calculateScore(n)
	shieldPower = shieldPower + n*8
	rowCount = rowCount + n
	if n == 0 then
		combo = 0
	else
		local tmpScore
		combo = combo + n
		if combo >= 10 then
			combo = combo + 5
		end
		if n == 1 then
			tmpScore = 20
		elseif n == 2 then
			tmpScore = 50
		elseif n == 3 then
			tmpScore = 100
		elseif n == 4 then
			tmpScore = 200
			openDialog(2) --test, open Troi
		end
		tmpScore = tmpScore + (combo-1) * 10
		score = score + tmpScore
	end
end

function drawScore()
	love.graphics.print(string.format("Rows: %s", rowCount), 420, 215)
	love.graphics.print(string.format("Credit: %s", score), 420, 230)
end