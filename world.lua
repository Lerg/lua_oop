local map_class = require('map')

local object_count = 100000
local step_count = 20

local results = {}

collectgarbage('stop')
local previous_memory = collectgarbage('count')

local function start_world(classes_name)
	local classes = require('classes.' .. classes_name)
	local map = map_class.new(1000, 1000)

	math.randomseed(69)

	local start_time = os.clock()

	for i = 1, math.floor(object_count / 10) do
		local flower = classes.new_flower(math.random(0, map.width - 1), math.random(0, map.height - 1))
		map:enter(flower)
		table.insert(map.objects, flower)
	end

	for i = 1, object_count do
		local human = classes.new_human(math.random(0, map.width - 1), math.random(0, map.height - 1))
		map:enter(human)
		table.insert(map.objects, human)
	end

	for i = 1, object_count do
		local zombie = classes.new_zombie(math.random(0, map.width - 1), math.random(0, map.height - 1))
		map:enter(zombie)
		table.insert(map.objects, zombie)
	end

	local creation_time = os.clock()

	for i = 1, step_count do
		for j = 1, #map.objects do
			local object = map.objects[j]
			if not object.is_invalid and object.update then
				object:update(map)
			end
		end
	end

	local simulation_time = os.clock()

	local memory = collectgarbage('count')
	local result = {
		name = classes_name,
		creation = creation_time - start_time,
		simulation = simulation_time - creation_time,
		flowers = 0,
		humans = 0,
		zombies = 0,
		memory = memory - previous_memory
	}
	previous_memory = memory

	for i = 1, #map.objects do
		local object = map.objects[i]
		if not object.is_invalid then
			if object.is_flower then
				result.flowers = result.flowers + 1
			elseif object.is_human then
				result.humans = result.humans + 1
			elseif object.is_zombie then
				result.zombies = result.zombies + 1
			end
		end
	end

	table.insert(results, result)
end

start_world('mt')
start_world('plain')
start_world('predef')

-- Find minimal times.
local min_creation_time, min_simulation_time = results[1].creation, results[1].simulation
for i = 2, #results do
	local r = results[i]
	if r.creation < min_creation_time then
		min_creation_time = r.creation
	end
	if r.simulation < min_simulation_time then
		min_simulation_time = r.simulation
	end
end

-- Sort.
--table.sort(results, function(a, b) return a.creation < b.creation end)
--table.sort(results, function(a, b) return a.simulation < b.simulation end)

-- Print results.
local f = function(n, p) return string.format('%.' .. (tostring(p or 2)) .. 'f', n) end
print('object count: ' .. f(object_count, 0), 'step count: ' .. f(step_count, 0))
for i = 1, #results do
	local r = results[i]
	print(
		r.name,
		'create: ' .. f(r.creation, 5) .. 's' .. ' (' .. f(100 * r.creation / min_creation_time, 1) .. '%)',
		'simulate: ' .. f(r.simulation) .. 's' .. ' (' .. f(100 * r.simulation / min_simulation_time, 1) .. '%)',
		'memory: ' .. f(r.memory / 1024, 1) .. 'MB',
		'f: ' .. f(r.flowers, 0) .. ' h: ' .. f(r.humans, 0) .. ' z: ' .. f(r.zombies, 0)
	)
end