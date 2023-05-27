local gstr = require 'gears.string'
local vimkey_to_awesome = {
    ['Esc']   = 'Escape',
    ['CR']    = 'Return',
    ['Space'] = 'space',
    ['[']     = 'bracketleft',
    [']']     = 'bracketright',
    ['BS']    = 'BackSpace',
}

local modifier_to_char = {
    ['C'] = 'Control',
    ['S'] = 'Shift',
    ['A'] = 'Mod1',
    ['M'] = 'Mod4',
}

local ignore_keys = {
    Mod2 = true,
}

local function tbl_swap(tbl)
    local new_tbl = {}
    for k, v in pairs(tbl) do
        new_tbl[v] = k
    end
    return new_tbl
end
local awesome_to_vimkey = tbl_swap(vimkey_to_awesome)
local char_to_modifier = tbl_swap(modifier_to_char)

---A Utility for parsing vim key mappings to awesome key
---@param vim_key_sequence string @vim key mapping
local function split_to_keys(vim_key_sequence)
    local keys = {}
    local size = 0
    local cur, len = 1, #vim_key_sequence
    while cur <= len do
        size = size + 1
        local end_pos = vim_key_sequence:sub(cur, cur) == '<'
            and vim_key_sequence:find('>', cur)
            or cur
        keys[size] = vim_key_sequence:sub(cur, end_pos)
        cur = end_pos + 1
    end
    return keys, size
end

---A Utility for parsing vim key mappings to awesome key
---@param vim_key string @vim key mapping **Single**
---@return string[], key
local function vimkey_to_key(vim_key)
    -- Parse modifiers
    if #vim_key == 1 then
        -- check if it is a upper case
        if vim_key:match '%u' then
            return { 'Shift' }, vim_key
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
        local modifier = modifier_to_char[keys[i]]
        assert(modifier)
        modifiers[i] = modifier
    end

    return modifiers, vimkey_to_awesome[keys[size]] or keys[size]
end

---A Utility for parsing awesome key mappings to vim key
---@param modifiers string[]
---@param key string
---@return string
local function key_to_vimkey(modifiers, key)
    local mods, size = {}, 0
    if key == ' ' then key = 'space' end -- Space is a special case
    key = awesome_to_vimkey[key] or key

    for _, modifier in ipairs(modifiers) do
        if not ignore_keys[modifier] then
            size = size + 1
            mods[size] = char_to_modifier[modifier]
        end
    end
    if #key > 1 then
        mods[size + 1] = key
        return '<' .. table.concat(mods, '-') .. '>'
    end

    if size == 0 or size == 1 and mods[1] == 'S' then return key end
    return '<' .. table.concat(mods, '-') .. '-' .. key .. '>'
end


local fake_input = root.fake_input
local run = awful.spawn
---Feed vim-like key to awesome
---@param vim_key string
local function feedkey(vim_key)
    -- FIXME : To Get Current modifiers so that we can release them

    -- local modifiers, key = vimkey_to_key(vim_key)
    -- local size = #modifiers
    --
    -- for i = 1, size do fake_input('key_press', modifiers[i]) end
    -- fake_input('key_press', key)
    -- fake_input('key_release', key)
    -- for i = size, 1, -1 do fake_input('key_release', modifiers[i]) end

    -- run('xdotool key ' .. vim_key)
    -- run('xdotool type ' .. vim_key)
end


---@class Mapper
---@field parser MapperParser

---@class MapperParser
---Export this module with const method
return {
    split_to_keys = split_to_keys,
    vimkey_to_key = vimkey_to_key,
    key_to_vimkey = key_to_vimkey,
    feedkey       = feedkey,
}
