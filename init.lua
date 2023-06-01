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
        local v = require(current_path .. key)
        rawset(self, key, v)
        return v
    end,
})

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

local emit_signal = awesome.emit_signal
do
    local function switch_to_mode(name)
        local to = M.modes[name]
        local from = M.current_mode
        emit_signal('mode::change', from, to)
        from:emit_signal('leave', from)
        to:emit_signal('enter', to)

        M.current_mode = to
        root.keys(to.keys)
    end

    M.switch_to_mode = switch_to_mode
    M.switch_to_mode_func = M.helper.cache_func(function(name)
        return function() switch_to_mode(name) end
    end)
end

---Create a new mode
---@param name string
---@param trigger? string vim-like key in default mode to switch to this mode
---@return MapperMode, fun(vim_key:keymap, action:function|table)
function M.new_mode(name, trigger)
    local mode = M.mode.new(name)
    emit_signal('mode::new', mode)

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
    M.default_mode = M.new_mode 'normal'
    M.current_mode = M.default_mode
end

function M.set(mode, vim_key, action)
    M.modes[mode]:set(vim_key, action)
end

---@alias stop_callback fun(grabber, stop_key, stop_event, sequence)
_G.mapper = M
return M
