# lua_oop
OOP tests for Lua.


Improving Lerg's metatables. They doesn't work on thier full potential

Tests were made on Lua 5.3.5

Here's original results:



object count: 100000    step count: 20


plain   create: 0.89400s (149.2%)       simulate: 10.32s (116.6%)       memory: 347.0MB f: 49916 h: 19725 z: 180275

predef  create: 0.59900s (100.0%)       simulate: 8.85s (100.0%)        memory: 241.7MB f: 49916 h: 19725 z: 180275

mt      create: 0.73900s (123.4%)       simulate: 10.48s (118.4%)       memory: 249.4MB f: 49916 h: 19725 z: 180275



Here's new results:



object count: 100000    step count: 20


plain   create: 0.89800s (206.9%)       simulate: 10.65s (115.4%)       memory: 347.0MB f: 49916 h: 19725 z: 180275

predef  create: 0.61200s (141.0%)       simulate: 9.23s (100.0%)        memory: 241.7MB f: 49916 h: 19725 z: 180275

new_mt  create: 0.43400s (100.0%)       simulate: 9.71s (105.2%)        memory: 166.8MB f: 49916 h: 19725 z: 180275




How you can see new meta's are better at creation but quite lacks on simulation part.
