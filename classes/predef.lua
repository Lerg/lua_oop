local _M = {}

-- Flower.

function _M.new_flower(x, y)
	local flower = {
		x = x, y = y,
		is_flower = true
	}
	return flower
end

-- Walkable.

local walkable_directions = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
local function walkable_walk(self, map)
	local direction = walkable_directions[math.random(#walkable_directions)]
	local x, y = self.x + direction[1], self.y + direction[2]
	if x > 0 and x < map.width and y > 0 and y < map.height then
		self.x, self.y = x, y
	end
end

function _M.new_walkable(x, y)
	local walkable = {
		x = x, y = y,
		walk = walkable_walk
	}
	return walkable
end

-- Human.

local function human_pick_flower(self, map)
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

local function human_update(self, map)
	map:leave(self)
	self:walk(map)
	map:enter(self)
	self:pick_flower(map)
end

function _M.new_human(x, y)
	local human = _M.new_walkable(x, y)
	human.is_human = true
	human.flower_count = 0

	human.pick_flower = human_pick_flower
	human.update = human_update
	
	return human
end

-- Zombie.

local function zombie_pick_brain(self, map)
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
local function zombie_update(self, map)
	map:leave(self)
	self:walk(map)
	map:enter(self)
	self:pick_brain(map)
end

-- new_zombie(human)
-- new_zombie(x, y
function _M.new_zombie(human_or_x, y)
	local zombie = type(human_or_x) == 'table' and human_or_x or _M.new_human(human_or_x, y)
	zombie.is_human = false
	zombie.is_zombie = true
	zombie.brain_count = 0
	
	zombie.pick_brain = zombie_pick_brain
	zombie.update = zombie_update

	return zombie
end

return _M
