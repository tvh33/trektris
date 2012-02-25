score = 0
combo = 0

function calculateScore(n)
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
		end
		tmpScore = tmpScore + (combo-1) * 10
		score = score + tmpScore
	end
end
