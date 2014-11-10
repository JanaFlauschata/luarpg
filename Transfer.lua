-- transfer class 
Transfer = {}

-- constructor
function Transfer:new(x, y, width, height, destination, newx, newy)
	local object = {
	x = x,
	y = y,
	width = width or 32,
	height = height or 32,
	destination = destination,
	newx = newx,
	newy = newy,
	}
	setmetatable(object, { __index = Transfer })
	return object
end

-- update transfer
function Transfer:update(dt)
end

-- keypressed callback
function Transfer:keypressed(key)
end

-- check a collision
function Transfer:iscollision(dt)
	if (herorat.x > self.x and herorat.x < self.x + self.width and herorat.y > self.y and herorat.y < self.y + self.height) then
		return true
	else
		return false		
	end
end

-- what to do on a collision
function Transfer:oncollision(dt)
	map = loader.load(self.destination..".tmx")
	layer = map("Objects")
	layer:toCustomLayer(convertobject)
	herorat.x = self.newx
	herorat.y = self.newy
end


-- draw transfer
function Transfer:draw()
	-- nothing to draw
end
