local _M = {}

-- Flower.

local flower_class = {
	is_flower = true
}

function _M.new_flower(x, y)
	local flower = {
		x = x, y = y
	}
	setmetatable(flower, {__index = flower_class})
	return flower
end

-- Walkable.

local walkable_class = {
	directions = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
}
function walkable_class:walk(map)
	local direction = self.directions[math.random(#self.directions)]
	local x, y = self.x + direction[1], self.y + direction[2]
	if x > 0 and x < map.width and y > 0 and y < map.height then
		self.x, self.y = x, y
	end
end

function _M.new_walkable(x, y)
	local walkable = {
		x = x, y = y
	}
	setmetatable(walkable, {__index = walkable_class})
	return walkable
end

-- Human.

local human_class = {
	is_human = true
}
setmetatable(human_class, {__index = walkable_class})
function human_class:pick_flower(map)
	local objects = map:get_objects(self.x, self.y)
	if objects then
		for k, object in pairs(objects) do
			if object.is_flower then
				self.flower_count = self.flower_count + 1
				object.is_invalid = true
				objects[k] = nil
			end
		end
	end
end
function human_class:update(map)
	map:leave(self)
	self:walk(map)
	map:enter(self)
	self:pick_flower(map)
end

function _M.new_human(x, y)
	local human = _M.new_walkable(x, y)
	human.flower_count = 0
	setmetatable(human, {__index = human_class})
	return human
end

-- Zombie.

local zombie_class = {
	is_zombie = true
}
setmetatable(zombie_class, {__index = human_class})
function zombie_class:pick_brain(map)
	local objects = map:get_objects(self.x, self.y)
	if objects then
		for k, object in pairs(objects) do
			if object.is_human then
				self.brain_count = self.brain_count + 1
				objects[k] = _M.new_zombie(k)
			end
		end
	end
end
function zombie_class:update(map)
	map:leave(self)
	self:walk(map)
	map:enter(self)
	self:pick_brain(map)
end

-- new_zombie(human)
-- new_zombie(x, y)
function _M.new_zombie(human_or_x, y)
	local zombie = type(human_or_x) == 'table' and human_or_x or _M.new_human(human_or_x, y)
	zombie.is_human = false
	zombie.brain_count = 0
	setmetatable(zombie, {__index = zombie_class})
	return zombie
end

return _M
