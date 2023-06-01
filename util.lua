local helper = mapper.helper
---@class Mapper
---@field util MapperUtil
---@class MapperUtil
local M = {}

do -- action_warp
    local mt = {
        __call = function(action_list)
            for _, action in ipairs(action_list) do action() end
        end,
    }

    ---A simple wrapper for multiple actions
    ---@param actions function[]
    M.action_warp = function(actions)
        return setmetatable(actions, mt)
    end
end

do
    local keygrabber = require 'awful.keygrabber'
    M.stop_grab = function()
        local grabber = keygrabber.current_instance()
        if grabber then grabber:stop() end
    end
end

M.wrap_func         = function(func)
    return function(...)
        local args = { ... }
        return function()
            return func(unpack(args))
        end
    end
end

M.run               = M.wrap_func(awful.spawn)

-- Export some functions from mapper.handler
local mapper        = mapper
M.switch_to_mode    = mapper.switch_to_mode_func
local default_name  = mapper.default_mode.name
M.switch_to_default = mapper.switch_to_mode_func(default_name)
M.bind_mode_map     = mapper.bind_mode_map
M.global_map        = mapper.bind_mode_map(default_name)


do
    -- FIXME :
    local fake_input = root.fake_input
    local with_ignore_modifiers = function(func, modifiers)
        if not modifiers then
            return func()
        end

        for _, modifier in ipairs(modifiers) do fake_input('key_release', modifier) end
        func()
        for _, modifier in ipairs(modifiers) do fake_input('key_press', modifier) end
    end

    M.send_string = function(key_sequence, modifiers)
        return function()
            with_ignore_modifiers(function()
                for i = 1, #key_sequence do
                    local char = key_sequence:sub(i, i)
                    fake_input('key_press', char)
                    fake_input('key_release', char)
                end
            end, modifiers)
        end
    end
end

---@alias client table

---utility for client map in mode map
---@param func fun(client:client)
---@return function
M.with_client = function(func)
    return function()
        local c = client.focus
        if c then func(c) end
    end
end

M.toggle_client = helper.cache_func(function(field)
    return function(c) c[field] = not c[field] end
end)


---Execute a function and then switch to default mode
---@param func fun()
---@return fun()
M.with_exec = function(func)
    return function()
        func()
        M.switch_to_default()
    end
end


return M
-- local fake_input = root.fake_input
-- local run = awful.spawn
-- ---Feed vim-like key to awesome
-- ---@param vim_key string
-- local function feedkey(vim_key)
--     -- FIXME : To Get Current modifiers so that we can release them
--
--     -- local modifiers, key = vimkey_to_key(vim_key)
--     -- local size = #modifiers
--     --
--     -- for i = 1, size do fake_input('key_press', modifiers[i]) end
--     -- fake_input('key_press', key)
--     -- fake_input('key_release', key)
--     -- for i = size, 1, -1 do fake_input('key_release', modifiers[i]) end
--
--     -- run('xdotool key ' .. vim_key)
--     -- run('xdotool type ' .. vim_key)
-- end
--

-- ---@param create fun(key:any)?:any The function called to create a missing value.
-- ---@return table Empty table with metamethod
-- function M.defaulttable(create)
--     create = create or function(_)
--         return M.defaulttable()
--     end
--     return setmetatable({}, {
--         __index = function(tbl, key)
--             local value = create(key)
--             rawset(tbl, key, value)
--             return value
--         end,
--     })
-- end
