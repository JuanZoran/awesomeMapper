local new_mode = mapper.mode.new
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
        [''] = new_mode '',
    },
    current_mode = '',
}

function M.get_mode(name)
    return M.modes[name]
end

function M.new_mode(name)
    local mode = new_mode(name)
    M.modes[name] = mode
    return mode
end

function M.switch_to_mode(name)
    M.current_mode = name
    root.keys(M.modes[name].keys)
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
