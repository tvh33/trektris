stars = {}
max_stars = 50
for i=1, max_stars do
	local x = math.random(32, 352)
	local y = math.random(0, 576)
	stars[i] = {x, y}
end

function updateStarfield(dt)

end

function drawStarfield()
	for i=1, #stars do
		love.graphics.point(stars[i][1], stars[i][2])
	end
end
