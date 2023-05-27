local util = mapper.util
local awful = require 'awful'
local function rawmap(mode, key, action, opts)
    --- TODO :
end

---@alias keymap string|any[]

---@param key any|any[]
local function parse_key(key)
    if type(key) == 'table' then
        local _key = key[#key]
        key[#key] = nil

        return key, _key
    end

    return {}, key
end

local function handle_first_arg_to(parse_func, gen_func)
    return function(str, ...)
        local modifiers, key = parse_func(str)
        return gen_func(modifiers, key, ...)
    end
end

local k = awful.key.new
local btn = awful.button
local vim_key = handle_first_arg_to(mapper.parser.vimkey_to_key, k)
local pack_key = handle_first_arg_to(parse_key, k)
local pack_mouse = handle_first_arg_to(parse_key, btn)


---map setter generator
---@param getkey_fun fun(key: keymap, action): string[], string
---@param set_fun fun(key: keymap, action: function)
local function pipe(getkey_fun, set_fun)
    ---@param key keymap
    ---@param action function
    return function(key, action)
        set_fun(getkey_fun(key, action))
    end
end

local kb  = awful.keyboard
local set = pipe(vim_key, kb.append_global_keybinding)


---@type MapperTrigger[]
local triggers = setmetatable({}, {
    __index = function(self, vim_key_trigger)
        local new_trigger = mapper.trigger.new(vim_key_trigger)
        set(vim_key_trigger, new_trigger:start_func())
        rawset(self, vim_key_trigger, new_trigger)
        return new_trigger
    end,
})

local function set_keymap(str, action)
    -- INFO : Check if is mulitple keymap
    local keys, size = mapper.parser.split_to_keys(str)
    assert(size > 0, str)
    local trig = keys[1]
    -- if is single keymap then just set the keymap
    if size == 1 then return set(trig, action) end

    -- else if is list then generate a grabber
    --      Check if already exists a grabber if not then generate a new one
    local cur = triggers[trig]
    -- find the last keymap processor
    for i = 2, size - 1 do cur = cur[keys[i]] end
    cur[keys[size]] = action
end


---@class Mapper
---@field keymap MapperMap
---@class MapperMap
---@operator call: fun(mode)
return {
    mode_map   = util.defaulttable(),
    rawmap     = rawmap,
    map        = pipe(pack_key, kb.append_global_keybinding),
    client_map = pipe(pack_key, kb.append_client_keybinding),
    -- set        = set,
    set        = set_keymap,
    client_set = pipe(vim_key, kb.append_client_keybinding),

    mouse        = pipe(pack_mouse, awful.mouse.append_global_mousebinding),
    client_mouse = pipe(pack_mouse, awful.mouse.append_client_mousebinding),
    vim_key      = vim_key,
}
