local util = mapper.util
local awful = require 'awful'
local kb = awful.keyboard
local k = awful.key
local btn = awful.button

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

---@class Mapper
---@field keymap MapperMap
---@class MapperMap
---@operator call: fun(mode)
return {
    mode_map   = util.defaulttable(),
    rawmap     = rawmap,
    map        = pipe(pack_key, kb.append_global_keybinding),
    client_map = pipe(pack_key, kb.append_client_keybinding),
    set        = pipe(vim_key, kb.append_global_keybinding),
    client_set = pipe(vim_key, kb.append_client_keybinding),


    mouse        = pipe(pack_mouse, awful.mouse.append_global_mousebinding),
    client_mouse = pipe(pack_mouse, awful.mouse.append_client_mousebinding),
    vim_key      = vim_key,
}
