local current_path = ... .. '.'

---@alias mode string
---@alias grabber table
---@alias modifier string
---@alias key string

---@class Mapper
---@field conf MapperConfig
---@field mode mode current mode
local M = setmetatable({}, {
    __index = function(self, key)
        self[key] = require(current_path .. 'core.' .. key)
        return self[key]
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
}


---Load user conf and set key map
---@param opts MapperConfig
function M.setup(opts)
    -- TODO :Handle opts
    for k, v in pairs(opts) do
        conf[k] = v
    end

    local awful = require 'awful'
    M.conf = conf
    M.mode = conf.init_mode


    assert(conf.trigger, 'Mapper.setup: opts.trigger is required')

    M.handler.exec()
end


--- Export this module
_G.mapper = M
return M
