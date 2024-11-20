-- Clear default snippets
require("luasnip.session.snippet_collection").clear_snippets "rust"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("rust", {
	s("for", fmt([[
        for {} in {} {{
            {}
        }}
    ]], {
            i(1, "i"),
            i(2, "iterable"),
            i(3, "body"), })),
})
