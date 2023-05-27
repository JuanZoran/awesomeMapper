---@class Mapper
---@field util MapperUtil

---@class MapperUtil
local M = {}

---@param create fun(key:any)?:any The function called to create a missing value.
---@return table Empty table with metamethod
function M.defaulttable(create)
    create = create or function(_)
        return M.defaulttable()
    end
    return setmetatable({}, {
        __index = function(tbl, key)
            local value = create(key)
            rawset(tbl, key, value)
            return value
        end,
    })
end

M.list = (function()
    ---@class list
    local mt = {
        append = function(self, value)
            self.size = self.size + 1
            self[self.size] = value
        end,
    }
    mt.__index = mt

    ---A simple list
    ---@return list
    return function()
        return setmetatable({
            size = 0,
        }, mt)
    end
end)()


M.action_warp = (function()
    local mt = {
        __call = function(actions)
            for _, action in ipairs(actions) do action() end
        end,
    }

    ---A simple wrapper for multiple actions
    ---@param actions function[]
    return function(actions)
        return setmetatable(actions, mt)
    end
end)()

local keygrabber = require 'awful.keygrabber'
M.stop_grab = function()
    local grabber = keygrabber.current_instance()
    if grabber then grabber:stop() end
end

M.wrap_func = function(func)
    return function(...)
        local args = ...
        return function()
            return func(args)
        end
    end
end

local function get_key(tbl, key)
    return tbl[key]
end

M.switch_to_mode = setmetatable({}, {
    __index = function(tbl, name)
        local res = function() mapper.handler.switch_to_mode(name) end
        rawset(tbl, name, res)
        return res
    end,
    __call = get_key,
})

M.bind_mode_map = setmetatable({}, {
    __index = function(tbl, mode)
        local _mode = mapper.handler.get_mode(mode)
        local res = function(...) _mode:set(...) end
        rawset(tbl, mode, res)
        return res
    end,
    __call = get_key,
})


return M
