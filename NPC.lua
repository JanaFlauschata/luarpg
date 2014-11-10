-- NPC class 
NPC = {}

require("AnAL")

local speed = 50
local animSpeed = 0.3
local animSpeedWait = 1

-- constructor
function NPC:new(x, y, colour, messages, talk)
	-- TODO not use messages
	dofile("npcs/"..messages..".lua")

	local object = {
	x = x + 16,
	y = y + 16,
	speed = speed,
	direction = "none",
	colour = colour or "fawnhooded",
	messages = messages,
	talk = testnpctalk,
	}
	setmetatable(object, { __index = NPC })

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
function NPC:update(dt)
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

-- keypressed callback
-- have a wider range for starting conversation
function NPC:keypressed(key)
	local nosex, nosey = herorat:getNoseCoordinates()
	if (key == "return" and nosex > self.x - 32 and nosex < self.x + 32 and nosey > self.y - 32 and nosey < self.y + 32) then
		loadstring(self.talk)
		--_G[self.talk]()
	end
end

-- what to do on a collision
function NPC:iscollision(dt)
	-- get coordinates of hero rat's nose
	local nosex, nosey = herorat:getNoseCoordinates()
	if (nosex > self.x - 15 and nosex < self.x + 16 and nosey > self.y - 15 and nosey < self.y + 16) then
		return true
	else return false
	end
end

-- what to do on a collision
function NPC:oncollision(dt)
end

-- draw NPC
function NPC:draw()
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

-- change direction functions
function NPC:moveLeft()
	self.direction = "left"
end

function NPC:moveRight()
	self.direction = "right"
end

function NPC:moveUp()
	self.direction = "up"
end

function NPC:moveDown()
	self.direction = "down"
end

function NPC:stop()
	self.direction = "none"
end
