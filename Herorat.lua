-- hero rat class 
Herorat = {}

require("AnAL")

local speed = 50
local animSpeed = 0.3
local animSpeedWait = 1

-- constructor
function Herorat:new(x, y, colour)
	local object = {
	x = x,
	y = y,
	speed = speed,
	direction = "none",
	colour = colour or "fawnhooded",
	}
	setmetatable(object, { __index = Herorat })

	-- load sprite images
	local up  = love.graphics.newImage("Testrat/" .. object.colour .. "/up/up.png")
	up:setFilter("nearest","nearest")
	local down  = love.graphics.newImage("Testrat/" .. object.colour .. "/down/down.png")
	down:setFilter("nearest","nearest")
	local left  = love.graphics.newImage("Testrat/" .. object.colour .. "/left/left.png")
	left:setFilter("nearest","nearest")
	local right  = love.graphics.newImage("Testrat/" .. object.colour .. "/right/right.png")
	right:setFilter("nearest","nearest")
	local wait  = love.graphics.newImage("Testrat/" .. object.colour .. "/wait/wait.png")
	wait:setFilter("nearest","nearest")

	-- create animations
	object.anim = {up = newAnimation(up, 32, 64, animSpeed, 0), down = newAnimation(down, 32, 64, animSpeed, 0), left = newAnimation(left, 64, 32, animSpeed, 0), right = newAnimation(right, 64, 32, animSpeed, 0), wait = newAnimation(wait, 32, 32, animSpeedWait, 0)}

	return object
end

-- update animation
function Herorat:update(dt)
	if self.direction == "left" then
		self.anim.left:update(dt)
		self.x = self.x - self.speed*dt
	elseif self.direction == "right" then
		self.anim.right:update(dt)
		self.x = self.x + self.speed*dt
	elseif self.direction == "up" then
		self.anim.up:update(dt)
		self.y = self.y - self.speed*dt
	elseif self.direction == "down" then
		self.anim.down:update(dt)
		self.y = self.y + self.speed*dt
	elseif self.direction == "none" then
		self.anim.wait:update(dt)
	end
end

-- move back rat
function Herorat:moveback(dt)
	if self.direction == "left" then
		self.x = self.x + self.speed*dt
	elseif self.direction == "right" then
		self.x = self.x - self.speed*dt
	elseif self.direction == "up" then
		self.y = self.y + self.speed*dt
	elseif self.direction == "down" then
		self.y = self.y - self.speed*dt
	end
end

-- draw rat
function Herorat:draw()
	if self.direction == "left" then
		self.anim.left:draw(self.x-15, self.y-16)
	elseif self.direction == "right" then
   	self.anim.right:draw(self.x-48, self.y-16)
	elseif self.direction == "down" then
		self.anim.down:draw(self.x-15, self.y-48)
	elseif self.direction == "up" then
		self.anim.up:draw(self.x-15, self.y-15)
	elseif self.direction == "none" then
		self.anim.wait:draw(self.x-15,self.y-15)
	end
end

-- what happens when a key is pressed
function Herorat:keypressed(key)
	if key == "left" then
		self:moveLeft()
	elseif key == "right" then
		self:moveRight()
	elseif key == "up" then
		self:moveUp()
	elseif key == "down" then
		self:moveDown()
	end
end

-- what happens when a key is released
function Herorat:keyreleased(key)
	if key == "left" or "right" or "up" or "down" then
		self:stop()
	end
	if love.keyboard.isDown("left") then
		self:moveLeft()
	elseif love.keyboard.isDown("right") then
		self:moveRight()
	elseif love.keyboard.isDown("up") then
		self:moveUp()
	elseif love.keyboard.isDown("down") then
		self:moveDown()
	end
end

-- change direction functions
function Herorat:moveLeft()
	self.direction = "left"
end

function Herorat:moveRight()
	self.direction = "right"
end

function Herorat:moveUp()
	self.direction = "up"
end

function Herorat:moveDown()
	self.direction = "down"
end

function Herorat:stop()
	self.direction = "none"
end

-- return coordinates of the rat's nose
function Herorat:getNoseCoordinates()
	if self.direction == "right" then
		return self.x + 16, self.y
	elseif self.direction == "left" then
		return self.x - 15, self.y 
	elseif self.direction == "up" then
		return self.x, self.y - 15
	elseif self.direction == "down" then
		return self.x, self.y + 16
	else
		return self.x, self.y
	end
end

-- return coordinates of the rat's left ear
function Herorat:getLeftEarCoordinates()
	if self.direction == "right" then
		return self.x + 16, self.y - 15
	elseif self.direction == "left" then
		return self.x - 15, self.y + 16 
	elseif self.direction == "up" then
		return self.x - 15, self.y - 15
	elseif self.direction == "down" then
		return self.x + 16, self.y + 16
	else
		return self.x + 16, self.y - 15
	end
end

-- return coordinates of the rat's right ear
function Herorat:getRightEarCoordinates()
	if self.direction == "right" then
		return self.x + 16, self.y + 16
	elseif self.direction == "left" then
		return self.x - 15, self.y - 15
	elseif self.direction == "up" then
		return self.x + 16, self.y - 15
	elseif self.direction == "down" then
		return self.x - 15, self.y + 16
	else
		return self.x - 15, self.y - 15
	end
end

-- collision detection
function Herorat:iscollision(dt)
	local direction = self.direction
	if direction == "none" then
		return false
	end

	-- get coordinates of rat's nose
	local noseX, noseY = self:getNoseCoordinates()
	
	-- get tile
	local tileX = noseX/32 - (noseX/32)%1
	local tileY = noseY/32 - (noseY/32)%1
	local tile = map("Meta")(tileX, tileY)

	-- get belly tile
	local bellytileX = self.x/32 - (self.x/32)%1
	local bellytileY = self.y/32 - (self.y/32)%1	
	local bellytile = map("Meta")(bellytileX, bellytileY)

	-- check whether tile is an obstacle
  	if tile and tile.properties.obstacle then 
		if (direction == "right" and tile.properties.left and bellytile ~= tile)
		or (direction == "left" and tile.properties.right and bellytile ~= tile)
		or (direction == "up" and tile.properties.down and bellytile ~= tile)
		or (direction == "down" and tile.properties.up and bellytile ~= tile) then
			return true
		end
	end 

	-- check whether the hero rat collides with an object and perform what happens on a collision
	-- in case the collision changes map and layers keep a copy of the object layer
	copylayer = shallowcopy(layer)
	for i = 1, #copylayer.objects do
		local object = copylayer.objects[i]
		if (object:iscollision()) then
			object:oncollision(dt)
			return true
		end
	end
	
	return false
end
