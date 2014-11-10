require "Herorat"
require "NPC"
require "Transfer"

-- put somewhere else
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- create object conversion function
local function convertobject(objectold)	
	if (objectold.type == "NPC") then
		object = NPC:new(objectold.x,objectold.y,objectold.properties.colour,objectold.properties.messages,objectold.properties.talk)
	end
	if (objectold.type == "transfer") then
		object = Transfer:new(objectold.x,objectold.y,objectold.width,objectold.height,objectold.properties.destination,objectold.properties.newx,objectold.properties.newy)
	end

	return object
end

function love.load()
	scale = 2

	-- load map
	loader = require("Advanced-Tiled-Loader.Loader")
	loader.path = "Testmap/"
	map = loader.load("testmap.tmx")

	-- create hero rat
	herorat = Herorat:new(150,150,"fawnhooded")

	-- load message library
	_navi = require 'arc'

	-- create test message	
	msg1 = _navi:new("Huhu! Mein Name ist Herorat und ich wurde gerade mit GitHub synchronisiert.",{name = "Herorat", wbox = love.graphics.getWidth()/scale, nrows = 5})

	layer = map("Objects")
	layer:toCustomLayer(convertobject)

	-- custom layer draw function
	function layer:draw()
    		for k,obj in pairs(self.objects) do
        		obj:draw()
    		end
	end
	-- custom layer keypressed function
	function layer:keypressed(key)
    		for k,obj in pairs(self.objects) do
        		obj:keypressed(key)
    		end
	end
end

function love.update(dt)
	-- messaging
	arc.check_keys(dt)

	-- update rat
	herorat:update(dt)

	-- update objects
	for i = 1, #layer.objects do
		local object = layer.objects[i]
		object:update(dt)
	end

	-- check for collision
	if herorat:iscollision(dt) then
		herorat:moveback(dt)
	end
end

function love.keypressed(key)
	-- messaging
	arc.set_key(key)

	-- move rat
	herorat:keypressed(key)

	-- forward key to map objects
	map:callback("keypressed",key)
end

function love.keyreleased(key)
	-- stop rat
	herorat:keyreleased(key)
end

function love.draw()
	-- scale drawing
	love.graphics.scale(scale)

	-- translation for map scrolling
	local tx = -1 * herorat.x + (love.graphics.getWidth()/2)/scale
	local ty = -1 * herorat.y + (love.graphics.getHeight()/2)/scale
	love.graphics.translate(tx,ty)

	-- configure map
	map:setDrawRange(0,0,love.graphics.getWidth(),love.graphics.getHeight())
	map:autoDrawRange(tx, ty, scale, padding)

	-- draw map
	map:draw()

	-- draw rat
	herorat:draw()

	-- get foreground layer and draw it again on top
	map("Foreground"):draw()

	-- reset coordinate transformation
	love.graphics.origin()

	-- scale drawing
	love.graphics.scale(scale)

	-- messaging
	msg1:play(0,love.graphics.getHeight()/scale-80)
	arc.clear_key()
end
