local util = mapper.util
local awful = require 'awful'
local k = awful.key
local btn = awful.button

local function setup()
    --- TODO :
    -- root.keys(M.global_key)
    -- awful.keyboard.append_global_keybindings(M.global_key)
    -- awful.keyboard.append_client_keybindings(M.client_key)
end

local function rawmap(mode, key, action, opts)
    --- TODO :
end

---@param key any|any[]
local function parse_key(key)
    if type(key) == 'table' then
        local _key = key[#key]
        key[#key] = nil

        return key, _key
    end

    return {}, key
end


local function client_map(key, action, opts)
    -- opts = opts or empty_dict
    local modifiers, _key = parse_key(key)
    awful.keyboard.append_client_keybinding(k(modifiers, _key, action))
end


---A Simple wrapper for global keybindings
---@param key string|string[]
---@param action function
---@param opts table?
local function map(key, action, opts)
    -- TODO : Handle opts
    opts = opts or {}
    if opts.client then
        return client_map(key, action, opts)
    end

    local modifiers, _key = parse_key(key)
    awful.keyboard.append_global_keybinding(k(modifiers, _key, action))
end


---A Simple wrapper for global keybindings
---@param vim_key string
---@param action function
---@param opts table?
local function client_set(vim_key, action, opts)
    local modifiers, _key = mapper.parser.vimkey_to_key(vim_key)
    awful.keyboard.append_client_keybinding(k(modifiers, _key, action))
end

---A Simple wrapper for global keybindings
---@param vim_key string
---@param action function
---@param opts table?
local function set(vim_key, action, opts)
    -- TODO : Handle opts
    opts = opts or {}
    if opts.client then
        return client_map(vim_key, action, opts)
    end

    local modifiers, _key = mapper.parser.vimkey_to_key(vim_key)
    awful.keyboard.append_global_keybinding(k(modifiers, _key, action))
end


---A Simple wrapper for global mouse bindings
---@param button integer|table # The button to bind.
---@param on_press function?
---@param on_release function?
local function mouse(button, on_press, on_release)
    local modifiers, key = parse_key(button)
    local _botton = btn(modifiers, key, on_press, on_release)
    awful.mouse.append_global_mousebinding(_botton)
end


---A Simple wrapper for global mouse bindings
---@param button integer|table # The button to bind.
---@param on_press function?
---@param on_release function?
local function client_mouse(button, on_press, on_release)
    local modifiers, key = parse_key(button)
    local _botton = btn(modifiers, key, on_press, on_release)
    awful.mouse.append_client_mousebinding(_botton)
end


---@class Mapper
---@field keymap MapperMap
---@class MapperMap
---@operator call: fun(mode)
return {
    mode_map = util.defaulttable(),
    rawmap = rawmap,
    setup = setup,
    map = map,
    client_map = client_map,
    mouse = mouse,
    client_mouse = client_mouse,
    set = set,
    client_set = client_set,
}

-- return setmetatable(M, {
--     ---Neovim-vim.keymap.set like function
--     ---@param mode mode
--     ---@param lhs string
--     ---@param rhs function
--     ---@param opts table
--     __call = function(mode, lhs, rhs, opts)
--     end,
-- })
