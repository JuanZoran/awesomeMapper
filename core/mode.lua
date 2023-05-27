---@class MapperMode
---@field keymaps table<string, function|table>
---@field keys list generated from keymaps
---@field name string current mode name
local M = {
}

M.__index = M

---@class Mapper
---@field mode MapperMode

local mapper = mapper
local keymap = mapper.keymap
function M:add_single_key(vim_key, action)
    local new_key = keymap.vim_key(vim_key, action)
    self.keymaps[vim_key] = new_key

    if self.name == mapper.handler.current_mode then
        keymap.add_global_key(new_key, action)
    end
    self.keys:append(new_key)
end

local split_to_keys = mapper.parser.split_to_keys
function M:set(vim_key, action)
    local keys, size = split_to_keys(vim_key)
    -- INFO : Check if is mulitple keymap
    local trig = keys[1]
    -- if is single keymap then just set the keymap
    if size == 1 then return self:add_single_key(trig, action) end


    -- else if is list then generate a grabber
    --      Check if already exists a grabber if not then generate a new one
    local cur = self.keymaps[trig]
    for i = 2, size - 1 do cur = cur[keys[i]] end -- find the last keymap processor
    cur[keys[size]] = action
end

local create_trigger = mapper.trigger.new
---@class list
local list_mt = {
    append = function(self, value)
        self.size = self.size + 1
        self[self.size] = value
    end,
}
list_mt.__index = list_mt
---Create a new mode
---@param name string
---@return MapperMode
function M.new(name)
    local instance = setmetatable({
        keymaps = {},
        keys = setmetatable({ size = 0 }, list_mt),
        name = name,
    }, M)

    setmetatable(instance.keymaps, {
        __index = function(self, vim_key_trigger)
            local new_trigger = create_trigger(vim_key_trigger)
            instance:add_single_key(vim_key_trigger, new_trigger)

            rawset(self, vim_key_trigger, new_trigger)
            return new_trigger
        end,
    })
    return instance
end

return M
