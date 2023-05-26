local gstr = require 'gears.string'

-- [Vim-key] => [Awesome-key]: {Modifiers, Key}
-- local cases = {
--     ['a']         = { {}, 'a' },
--     ['A']         = { { 'Shift' }, 'a' },
--     ['<C-a>']     = { { 'Control' }, 'a' },
--     ['<Tab>']     = { {}, 'Tab' },
--     ['<C-Tab>']   = { { 'Control' }, 'Tab' },
--     ['<C-S-Tab>'] = { { 'Shift', 'Control' }, 'Tab' },
--     ['<C-S-a>']   = { { 'Shift', 'Control' }, 'a' },
-- }
local spec_keys = {
    ['Esc'] = 'Escape',
    ['CR'] = 'Return',
    ['Space'] = 'space',
}

local modifier_map = {
    ['C'] = 'Control',
    ['S'] = 'Shift',
    ['A'] = 'Mod1',
    ['M'] = 'Mod4',
}

---A Utility for parsing vim key mappings to awesome key
---@param vim_key string @vim key mapping
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

    return modifiers, spec_keys[keys[size]] or keys[size]
end

---A Utility for parsing awesome key mappings to vim key
---@param modifiers string[]
---@param key string
---@return string
local function key_to_vimkey(modifiers, key)
    -- local rex_pcre = require 'rex_pcre'
    -- local re = rex_pcre.new('')
end

---@class Mapper
---@field parser MapperParser

---@class MapperParser
return {
    vimkey_to_key = vimkey_to_key,
}
