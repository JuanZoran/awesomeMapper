local gstr = require 'gears.string'
local vimkey_awesome_map = {
    ['Esc'] = 'Escape',
    ['CR'] = 'Return',
    ['Space'] = 'space',
}
local awesome_vimkey_map = {}
do
    for k, v in pairs(vimkey_awesome_map) do
        awesome_vimkey_map[v] = k
    end
end

local modifier_map = {
    ['C'] = 'Control',
    ['S'] = 'Shift',
    ['A'] = 'Mod1',
    ['M'] = 'Mod4',
}

---A Utility for parsing vim key mappings to awesome key
---@param vim_key_sequence string @vim key mapping
local function split_to_keys(vim_key_sequence)
    local keys = {}
    local cur, len = 1, #vim_key_sequence
    while cur <= len do
        if vim_key_sequence:sub(cur, cur) == '<' then
            local _, end_pos = vim_key_sequence:find('>', cur)
            keys[#keys + 1] = vim_key_sequence:sub(cur, end_pos)
            cur = end_pos + 1
        else
            keys[#keys + 1] = vim_key_sequence:sub(cur, cur)
            cur = cur + 1
        end
    end
    return keys
end

---A Utility for parsing vim key mappings to awesome key
---@param vim_key string @vim key mapping **Single**
---@return string[], key
local function vimkey_to_key(vim_key)
    -- Parse modifiers
    if #vim_key == 1 then
        -- check if it is a upper case
        if vim_key:match '%u' then
            return { 'Shift' }, vim_key:lower()
        else
            return {}, vim_key
        end
    end

    -- local keys = gstr.split(vim_key:match '<(.+)>', '-')
    local keys = gstr.split(vim_key:sub(2, #vim_key - 1), '-')

    local size = #keys
    assert(size ~= 0)

    local modifiers = {}
    for i = 1, size - 1 do
        -- modifiers[i] = modifier_map[keys[i]]
        local modifier = modifier_map[keys[i]]
        assert(modifier)
        modifiers[i] = modifier
    end

    return modifiers, vimkey_awesome_map[keys[size]] or keys[size]
end

---A Utility for parsing awesome key mappings to vim key
---@param modifiers string[]
---@param key string
---@return string
local function key_to_vimkey(modifiers, key)
    return ''
end


---@class Mapper
---@field parser MapperParser

---@class MapperParser
return {
    vimkey_to_key = vimkey_to_key,
    split_to_keys = split_to_keys,
}
