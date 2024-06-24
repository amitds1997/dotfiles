local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "neet_code",
    fmt([[
/*
* Problem link: {1}
 *
 * Key idea:
 * {5}
 *
 * Approach:
 * {6}
 *
 * Time complexity:
 * {7}
 *
 * Space complexity:
 * {8}
 *
*/
pub struct Solution {{}}

impl Solution {{
    pub fn {2}({3}) -> {4} {{
    }}
}}

#[cfg(test)]
mod tests {{
    use super::*;

    #[test]
    fn solution_{9}() {{}}
}}
  ]], {
    i(1, "problem_source"),
    i(2, "function_name"),
    i(3, "function_args"),
    i(4, "function_return"),
    i(5, "key_idea"),
    i(6, "approach"),
    i(7, "time_complexity"),
    i(8, "space_complexity"),
    rep(2),
  })
  ),
}
