local _M = {}

function _M.new_flower(x, y)
	local flower = {
		x = x, y = y,
		is_flower = true
	}
	return flower
end

function _M.new_walkable(x, y)
	local walkable = {
		x = x, y = y
	}
	local directions = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
	function walkable:walk(map)
		local direction = directions[math.random(#directions)]
		local x, y = self.x + direction[1], self.y + direction[2]
		if x > 0 and x < map.width and y > 0 and y < map.height then
			self.x, self.y = x, y
		end
	end
	return walkable
end

function _M.new_human(x, y)
	local human = _M.new_walkable(x, y)
	human.is_human = true
	human.flower_count = 0
	function human:pick_flower(map)
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
	function human:update(map)
		map:leave(self)
		self:walk(map)
		map:enter(self)
		self:pick_flower(map)
	end
	return human
end

-- new_zombie(human)
-- new_zombie(x, y
function _M.new_zombie(human_or_x, y)
	local zombie = type(human_or_x) == 'table' and human_or_x or _M.new_human(human_or_x, y)
	zombie.is_human = false
	zombie.is_zombie = true
	zombie.brain_count = 0
	function zombie:pick_brain(map)
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
	function zombie:update(map)
		map:leave(self)
		self:walk(map)
		map:enter(self)
		self:pick_brain(map)
	end
	return zombie
end

return _M
