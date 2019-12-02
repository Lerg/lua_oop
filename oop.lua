local sock_colors = {'red', 'green', 'blue'}

local function new_sock()
    local sock = {
        color = sock_colors[math.random(#sock_colors)],
        has_pair = false,
        is_lost = true
    }

    local protected = {
        material = 'wool'
    }

    local paired_sock

    function sock:get_lost()
        self.is_lost = true
    end
    function sock:pair(other_sock)
        if paired_sock ~= other_sock then
            paired_sock = other_sock
            self.has_pair = true
            other_sock:pair(self)
        end
    end
    function sock:get_pair()
        return paired_sock
    end

    function protected:set_name(name)
        sock.name = name
    end

    return sock, protected
end

local sock1, sock2 = new_sock(), new_sock()
sock1:pair(sock2)

local function new_sock_with_holes()
    local sock_with_holes, protected = new_sock()

    sock_with_holes.holes = {
        toe = true,
        heel = true
    }

    function sock_with_holes:get_material()
        return protected.material
    end

    protected:set_name('billy')

    return sock_with_holes
end

local sock_with_holes = new_sock_with_holes()

print('material', sock_with_holes:get_material())
print('name', sock_with_holes.name)

local pairable_interface = {
    pair = 'function',
    get_pair = 'function',
    has_pair = 'boolean'
}

local function implements(object, interface)
    for k, v in pairs(interface) do
        if not object[k] or type(object[k]) ~= v then
            return false
        end
    end
    return true
end

print('implements', implements(sock1, pairable_interface))


local stinky_mixin_selves = {}

local stinky_mixin = {
    is_stinking = false
}

function stinky_mixin:stink()
    local m = stinky_mixin_selves[self]
    m.is_stinking = true
end

function stinky_mixin:get_is_stinking()
    local m = stinky_mixin_selves[self]
    return m.is_stinking
end

local function add_mixin(object, mixin)
    local mixin_self = {}
    stinky_mixin_selves[object] = mixin_self
    for k, v in pairs(mixin) do
        if type(v) == 'function' then
            object[k] = v
        else
            mixin_self[k] = v
        end
    end
end

add_mixin(sock1, stinky_mixin)

sock1:stink()

print('is_stinking', sock1.is_stinking, sock1:get_is_stinking())