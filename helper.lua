---@class Mapper
---@field helper MapperHelper

---@class MapperHelper
local M = {}

M.cache_func = function(func)
    return setmetatable({}, {
        __index = function(self, key)
            local res = func(key)
            rawset(self, key, res)
            return res
        end,
        __call = function(self, key)
            return self[key]
        end,
    })
end

return M
