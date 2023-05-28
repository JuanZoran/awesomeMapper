local path = ... .. '.'
local conf = {
    color = {
        default = { bg = '#89b4fa', fg = '#181825' },
        { bg = '#89b4fa', fg = '#181825' },
        { bg = '#a6e3a1', fg = '#1e1e2e' },
        { bg = '#cba6f7', fg = '#1e1e2e' },
        { bg = '#fab387', fg = '#2b2733' },
    },
}

---@class MapperMode
---@field color {fg: string, bg: string}

local count = 0
mapper:connect_signal('mode::new', function(_, new_mode)
    count = count + 1
    new_mode.color = conf.color[count] or conf.color.default
end)

return function(opts)
    -- require'gears.table.merge'(conf)
    local textbox = require(path .. 'text')

    local container = require 'wibox.container'
    local widget = container.background(textbox, mapper.current_mode.color.bg, require 'gears.shape.rounded_rect')

    mapper:connect_signal('mode::change', function(_, _, to)
        widget.bg = to.color.bg
    end)
    return widget
end
