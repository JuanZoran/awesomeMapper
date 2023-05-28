---@class Mapper
---@field transformer MapperTransformer

local function clone()
    return {
        at = rawget,
    }
end

---@class MapperTransformer
---@field at fun(self: MapperTransformer, key: string): MapperTransformer | function|nil
local M = clone()

local function set_default_tbl(tbl, key)
    local instance = M.new()
    rawset(tbl, key, instance)
    return instance
end

M.clone = clone
M.set_default_tbl = set_default_tbl
setmetatable(M, {
    __index = set_default_tbl,
})


M.__index = M

---@nodiscard
---Constructor of MapperTransformer
---@param tbl table?
---@return MapperTransformer
function M.new(tbl)
    return setmetatable(tbl or {}, M)
end

return M
