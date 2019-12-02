local name = ''
local age = 0

local function f(method, arg1, arg2)
    if method == 'init' then
        name, age = arg1, arg2
        return f
    elseif method == 'say_hi' then
        print('Hi, my name is ' .. name .. ', I am ' .. tostring(age) .. ' years old.')
    elseif method == 'get_older' then
        age = age + 1
    elseif method == 'get_name' then
        return name
    elseif method == 'get_age' then
        return age
    end
end

return f