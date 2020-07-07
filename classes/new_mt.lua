-- Better mt

local flower ={
    is_flower = true;
    
}
flower.__index= flower


local directions = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
local Walk = function(self, map)
    
    local direction = directions[math.random(#directions)]
	local x, y = self.x + direction[1], self.y + direction[2]
	if x > 0 and x < map.width and y > 0 and y < map.height then
		self.x, self.y = x, y
    end
end

local walkable = {
    x = 0;
    y = 0;
    Walk = Walk;    
}


walkable.__index = walkable
-- common_methods





local update = function(self, map)
    map:leave(self)
	self:Walk(map)
	map:enter(self)
	self:pick(map)
end

--humans and zombies

local human_pick = function(self, map)
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


local human = new({
        is_human = true; 
        flower_count = 0; 
        update = update; 
        pick = human_pick;
        
    }, walkable
)
    
human.__index = human

local zombie_pick = function(self, map)
    local objects = map:get_objects(self.x, self.y)
	if objects then
		for k, object in pairs(objects) do
			if object.is_human then
                self.brain_count = self.brain_count + 1
                object.is_human = false
                new(object, self.virus)
                
			end
		end
	end
end

local zombie = new(
        {
        is_human = false;
        brain_count = 0;
        is_zombie = true;
        update = update;
        pick = zombie_pick;
    }, human
)
zombie.virus = zombie
zombie.__index = zombie



local _M = {zombie=zombie, human = human, flower = flower}
return _M