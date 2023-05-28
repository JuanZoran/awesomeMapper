local mode = require 'wibox.widget.textbox' (mapper.default_mode.name)
mapper:connect_signal('mode::change', function(_, _, to)
    mode:set_text(to.name)
end)

return mode
