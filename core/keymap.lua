local util = mapper.util
local awful = require 'awful'
local empty_dict = {}
-- local ruled = require 'ruled'

local function setup()
    --- TODO :
    -- root.keys(M.global_key)
    -- awful.keyboard.append_global_keybindings(M.global_key)
    -- awful.keyboard.append_client_keybindings(M.client_key)
end

local function rawmap(mode, key, action, opts)
    --- TODO :
end

local get_key = (function()
    local k = awful.key
    ---@param key string|string[]
    ---@param action function
    return function(key, action)
        local modifiers, _key
        if type(key) == 'string' then
            modifiers, _key = {}, key
        else
            _key = key[#key]
            key[#key] = nil
            modifiers = key
        end
        return k(modifiers, _key, action)
    end
end)()

local function client_map(key, action, opts)
    -- opts = opts or empty_dict
    local _key = get_key(key, action)
    awful.keyboard.append_client_keybinding(_key)
end


---A Simple wrapper for global keybindings
---@param key string|string[]
---@param action function
---@param opts table?
local function map(key, action, opts)
    -- TODO : Handle opts
    opts = opts or empty_dict
    if opts.client then
        return client_map(key, action, opts)
    end

    local _key = get_key(key, action)
    awful.keyboard.append_global_keybinding(_key)
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
    -- global_key = util.list(),
    -- client_key = util.list(),
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
