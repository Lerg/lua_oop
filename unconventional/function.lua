local john = require('function_class')('init', 'John', 28)

package.loaded['function_class'] = nil

local rebecca = require('function_class')('init', 'Rebecca', 21)

john('say_hi')
rebecca('say_hi')

john('get_older')

print(john('get_age'))