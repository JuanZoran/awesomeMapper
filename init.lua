local current_path = ... .. '.'

---@alias mode string
---@alias grabber table
---@alias modifier string
---@alias key string

---@class Mapper
---@field conf MapperConfig
local M = setmetatable({}, {
    __index = function(self, key)
        local v = require(current_path .. 'core.' .. key)
        rawset(self, key, v)
        return v
    end,
})

---@alias stop_callback fun(grabber, stop_key, stop_event, sequence)

---@class MapperConfig
local conf = {
    stop_key      = 'Escape',
    init_mode     = 'i', ---@type mode
    stop_callback = nil, ---@type stop_callback?
    trigger       = nil, ---@type string
    grabber       = nil, ---@type grabber
    ignored_keys = {
        Control_L = true,
        Control_R = true,
        Shift_L   = true,
        Shift_R   = true,
        Super_L   = true,
        Super_R   = true,
        Alt_L     = true,
        Alt_R     = true,
    },
}

---Load user conf and set key map
---@param opts MapperConfig
function M.setup(opts)
    M.conf = conf
end

--- Export this module
_G.mapper = M
return M
