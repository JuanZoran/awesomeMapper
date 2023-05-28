local keygrabber = require 'awful.keygrabber'

---@class MapperTrigger:MapperTransformer
---@field grabber table @awesome keygrabber
---@field trigger string @trigger key
---@field cur MapperTransformer @current transformer
---@operator call: function
local M = mapper.transformer.clone()
local set_default_tbl = mapper.transformer.set_default_tbl

M.__call = function(self)
    self.grabber:start()
end
M.__index = function(tbl, key)
    if M[key] then return M[key] end
    return set_default_tbl(tbl, key)
end

function M:fallback()
    self.grabber:stop()
    self.cur = self
end

local function callable(value)
    local valueType = type(value)
    if valueType == 'function' then
        return true
    elseif valueType == 'table' then
        local metatable = getmetatable(value)
        return metatable and metatable.__call ~= nil
    end

    return false
end


function M:invoke(_, modifiers, key)
    if mapper.conf.ignored_keys[key] then
        return
    end

    local vim_key = mapper.parser.key_to_vimkey(modifiers, key)

    local res = self.cur:at(vim_key)
    if not res then
        -- print('no such keymap: ' .. vim_key)
        return self:fallback()
    end

    ---@type MapperTransformer
    if callable(res) then
        self.cur = self -- reset the state pointer
        return res()
    end

    ---@cast res MapperTransformer
    self.cur = res
end

-- local default_stop_key = mapper.conf.stop_key
function M.new(vim_key_trigger, stop_key, stop_event)
    local instance = setmetatable({
        trigger = vim_key_trigger,
    }, M)

    instance.cur = instance -- init the state pointer
    instance.grabber = keygrabber {
        stop_key = stop_key,
        stop_event = stop_event,
        keypressed_callback = function(...)
            instance:invoke(...)
        end,
    }

    return instance
end

---@class Mapper
---@field trigger MapperTrigger
return M
