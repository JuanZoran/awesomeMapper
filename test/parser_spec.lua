local cases = {
    ['a']         = { {}, 'a' },
    ['A']         = { { 'Shift' }, 'a' },
    ['<C-a>']     = { { 'Control' }, 'a' },
    ['<Tab>']     = { {}, 'Tab' },
    ['<C-Tab>']   = { { 'Control' }, 'Tab' },
    ['<C-S-Tab>'] = { { 'Shift', 'Control' }, 'Tab' },
    ['<C-S-a>']   = { { 'Shift', 'Control' }, 'a' },
}

local parser = mapper.parser

for vim_key, awesome_key in pairs(cases) do
    print(vim_key, parser.vimkey_to_key(vim_key))
end
