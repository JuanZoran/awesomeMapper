local awful = require 'awful'
local conf = mapper.conf
---@class MapperHandler
local M = {}


M.ignored_keys = {
    Control_L = true,
    Control_R = true,
    Shift_L   = true,
    Shift_R   = true,
    Super_L   = true,
    Super_R   = true,
    Alt_L     = true,
    Alt_R     = true,
}


---Handle key pressed
---@param grabber grabber
---@param modifiers modifier[]
---@param key key
function M.handle(grabber, modifiers, key)
    if M.ignored_keys[key] then
        return
    end
    -- TODO :
    -- print(grabber)
    print(mapper.parser.key_to_vimkey(modifiers, key))
end

function M.exec()
    local grabber = awful.keygrabber {
        -- keybindings = {
        --     mapper.keymap.vim_key('j', function() print('Left') end),
        --     mapper.keymap.vim_key('l', function() print('Right') end),
        --     mapper.keymap.vim_key('i', function() print('Up') end),
        --     mapper.keymap.vim_key('k', function() print('Down') end),
        -- },
        stop_key            = conf.stop_key,
        stop_event          = 'press',
        -- stop_callback = conf.stop_callback,
        keypressed_callback = M.handle,
    }
    conf.grabber = grabber

    mapper.keymap.set(conf.trigger, function()
        grabber:start()
    end)
    -- mapper.keymap.setup()
end

---@class Mapper
---@field handler MapperHandler
return M
