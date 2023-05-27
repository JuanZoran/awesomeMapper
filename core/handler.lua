local new_mode = mapper.mode.new
local default_mode = 'default'
---@class MapperHandler
local M = {
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
    modes = {
        [default_mode] = new_mode(default_mode),
    },
    default_mode = default_mode,
    current_mode = default_mode,
}

function M.get_mode(name)
    return M.modes[name]
end

do
    function M.switch_to_mode(name)
        print('Now Switch to mode:' .. name)
        M.current_mode = name
        root.keys(M.modes[name].keys)
    end

    local function get_key(tbl, key)
        return tbl[key]
    end

    M.switch_to_mode_func = setmetatable({}, {
        __index = function(tbl, name)
            local res = function() M.switch_to_mode(name) end
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
end

---Create a new mode
---@param name string
---@param trigger? string vim-like key in default mode to switch to this mode
---@return MapperMode
function M.new_mode(name, trigger)
    local mode = new_mode(name)
    if trigger then
        M.modes[default_mode]:add_single_key(trigger, M.switch_to_mode_func(name))
    end
    M.modes[name] = mode
    return mode
end

function M.set(mode, vim_key, action)
    M.modes[mode]:set(vim_key, action)
end

---@class Mapper
---@field handler MapperHandler
return M

-- ---Handle key pressed
-- ---@param grabber grabber
-- ---@param modifiers modifier[]
-- ---@param key key
-- function M.handle(grabber, modifiers, key)
--     if M.ignored_keys[key] then
--         return
--     end
--     local vim_key = mapper.parser.key_to_vimkey(modifiers, key)
--     if vim_key == '<C-c>' then
--         grabber:stop()
--     end
--     print(vim_key)
-- end
--
-- function M.exec()
--     local grabber = awful.keygrabber {
--         stop_key            = conf.stop_key,
--         stop_event          = 'press',
--         -- stop_callback = conf.stop_callback,
--         keypressed_callback = M.handle,
--     }
--     conf.grabber = grabber
--     mapper.keymap.set(conf.trigger, function()
--         grabber:start()
--     end)
-- end
