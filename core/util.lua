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
        add = function(self, value)
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

return M
