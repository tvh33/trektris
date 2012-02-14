Brik = {xpos = 0, ypos = 0, rotation = 1, shape = 0}

function Brik:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Brik:incrX(dx)
	self.xpos = self.xpos + dx
end

function Brik:incrY(dy)
	self.ypos = self.ypos + dy
end

function Brik:getX()
	return self.xpos
end

function Brik:getY()
	return self.ypos
end

function Brik:setX(n)
	self.xpos = n
end

function Brik:setY(n)
	self.ypos = n
end

function Brik:getRotation()
	return self.rotation
end

function Brik:setRotation(r)
	self.rotation = r 
end

function Brik:rotate(dr)
	self.rotation = self.rotation + dr 
end

function Brik:setShape(s)
	self.shape = s
end

function Brik:getShape()
	return self.shape
end