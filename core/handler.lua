local awful = require 'awful'
local conf = mapper.conf

---@class MapperHandler
local M = {
}

---Handle key pressed
---@param grabber grabber
---@param modifiers modifier[]
---@param key key
function M.handle(grabber, modifiers, key)
    -- TODO :
    print('Modifiers: ', modifiers, 'Key:', key)
end

function M.exec()
    local grabber = awful.keygrabber {
        stop_key            = conf.stop_key,
        stop_event          = 'press',
        stop_callback       = conf.stop_callback,
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
