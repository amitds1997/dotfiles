local hyperlink_rules = require("wezterm").default_hyperlink_rules()

table.insert(hyperlink_rules, {
	regex = "(MLOPS-\\d+)",
	format = "https://honeycomb.jira.com/browse/$1",
})

return {
	hyperlink_rules = hyperlink_rules,
}
