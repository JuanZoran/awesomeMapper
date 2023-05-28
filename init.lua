local current_path = ... .. '.'
---@class gObject
---@field emit_signal fun(self:gObject, signal:string, ...)
---@field connect_signal fun(self:gObject, signal:string, callback:function)
---@field disconnect_signal fun(self:gObject, signal:string, callback:function)

---@alias mode string
---@alias grabber table
---@alias modifier string
---@alias key string

---@class Mapper:gObject
---@field conf MapperConfig
local M = {
    modes = {},
    bind_mode_map = setmetatable({}, {
        __call = rawget,
    }),
}

setmetatable(M, {
    __index = function(self, key)
        local v = require(current_path .. 'core.' .. key)
        rawset(self, key, v)
        return v
    end,
})
M = require 'gears.object' { class = M }

---@class MapperConfig
local conf = {
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

function M.get_mode(name)
    return M.modes[name]
end

do
    local function switch_to_mode(name)
        local to = M.modes[name]
        M:emit_signal('mode::change', M.current_mode, to)

        M.current_mode = to
        root.keys(to.keys)
    end

    M.switch_to_mode = switch_to_mode
    M.switch_to_mode_func = setmetatable({}, {
        __index = function(tbl, name)
            local res = function() switch_to_mode(name) end
            rawset(tbl, name, res)
            return res
        end,
        __call = function(tbl, key)
            return tbl[key]
        end,
    })
end

---Create a new mode
---@param name string
---@param trigger? string vim-like key in default mode to switch to this mode
---@return MapperMode, fun(vim_key:keymap, action:function|table)
function M.new_mode(name, trigger)
    local mode = M.mode.new(name)
    M:emit_signal('mode::new', mode)

    if trigger then
        M.default_mode:add_single_key(trigger, M.switch_to_mode_func(name))
    end

    local mode_map = function(...) mode:set(...) end
    M.bind_mode_map[name] = mode_map
    M.modes[name] = mode
    return mode, mode_map
end

M.setup = function(opts)
    M.conf = opts
    M.default_mode = M.new_mode 'default'
    M.current_mode = M.default_mode
end

function M.set(mode, vim_key, action)
    M.modes[mode]:set(vim_key, action)
end

---@alias stop_callback fun(grabber, stop_key, stop_event, sequence)
_G.mapper = M
return M
