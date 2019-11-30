local _M = {}

function _M.new(width, height)
	local map = {
		grid = {},
		width = width, height = height,
		objects = {}
	}
	function map:enter(object)
		local index = object.x + object.y * map.width
		if not map.grid[index] then
			map.grid[index] = {}
		end
		map.grid[index][object] = object
	end
	function map:leave(object)
		local index = object.x + object.y * map.width
		if map.grid[index] then
			map.grid[index][object] = nil
		end
	end
	function map:get_objects(x, y)
		return map.grid[x + y * map.width]
	end
	return map
end

return _M