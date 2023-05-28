local path = ... .. '.'
local conf = {
    color = {
        default = { bg = '#89b4fa', fg = '#181825' },
        { bg = '#89b4fa', fg = '#181825' },
        { bg = '#a6e3a1', fg = '#1e1e2e' },
        { bg = '#cba6f7', fg = '#1e1e2e' },
        { bg = '#fab387', fg = '#2b2733' },
    },
    get_mode_name = function(mode)
        return mode.name:upper()
    end,
}

local count = 0
local mode_color = setmetatable({}, {
    __index = function(self, name)
        count = count + 1
        local color = conf.color[count] or conf.color.default
        rawset(self, name, color)
        return color
    end,
})

---@class Mapper
---@field widget function get the widget
return function(opts)
    -- require'gears.table.merge'(conf)
    local mapper = mapper

    local get_mode_name = conf.get_mode_name
    local current_mode_name = get_mode_name(mapper.current_mode)
    local textbox = require 'wibox.widget.textbox' (current_mode_name)
    mapper:connect_signal('mode::change', function(_, _, to)
        textbox:set_text(get_mode_name(to))
    end)

    local container = require 'wibox.container'
    local c         = mode_color[current_mode_name]

    local widget    = require 'wibox.widget' {
        container.margin(textbox, 10, 10),
        widget = container.background,
        bg = c.bg,
        fg = c.fg,
        shape = require 'gears.shape'.rounded_rect,
    }

    mapper:connect_signal('mode::change', function(_, _, to)
        widget.bg = mode_color[get_mode_name(to)].bg
    end)
    return widget
end
