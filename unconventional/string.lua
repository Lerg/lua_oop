local object = '   James' .. string.char(20)

function string:say_hi()
    local name = self:sub(1, 8)
    local age = self:byte(9, 9)
    print('Hi, my name is ' .. name .. ', I am ' .. tostring(age) .. ' years old.')
end

object:say_hi()

local samanta = ' Samanta' .. string.char(24)

samanta:say_hi()