local name = {'Harry', 'Ron', 'Hermione'}
local age = {14, 15, 16}
local sex = {false, false, true}

local function say_hi(object)
    print('Hi, my name is ' .. name[object] .. ', I am ' .. tostring(age[object]) .. ' years old.')
end

local function set_age(object, value)
    age[object] = value
end

local harry, ron, hermione = 1, 2, 3

say_hi(harry)
say_hi(ron)
say_hi(hermione)

set_age(hermione, 18)
say_hi(hermione)