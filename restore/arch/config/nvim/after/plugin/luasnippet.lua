local ls = require("luasnip")

local function to_url(args)
    local txt = args[1][1]
	return txt:lower():gsub(" ", "_")
end

ls.add_snippets("markdown", {
	ls.snippet("newpage", {
		ls.text_node("["),
		ls.insert_node(1, "Link Name"),
		ls.text_node("](text:"),
        ls.function_node(to_url, 1),
		ls.text_node(")"),
		ls.insert_node(0)
	}),
})
