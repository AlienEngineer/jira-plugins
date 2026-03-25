-- GLOBAL
jira.keymaps.set("j", jira.cmd.go_down)
jira.keymaps.set("k", jira.cmd.go_up)
jira.keymaps.set("h", jira.cmd.go_left)
jira.keymaps.set("l", jira.cmd.go_right)

jira.keymaps.set("<DOWN>", jira.cmd.go_down)
jira.keymaps.set("<UP>", jira.cmd.go_up)
jira.keymaps.set("<LEFT>", jira.cmd.go_left)
jira.keymaps.set("<RIGHT>", jira.cmd.go_right)

function go_up_5()
	jira.cmd.go_up()
	jira.cmd.go_up()
	jira.cmd.go_up()
	jira.cmd.go_up()
	jira.cmd.go_up()
end
jira.keymaps.set("K", go_up_5)
function go_down_5()
	jira.cmd.go_down()
	jira.cmd.go_down()
	jira.cmd.go_down()
	jira.cmd.go_down()
	jira.cmd.go_down()
end
jira.keymaps.set("J", go_down_5)

jira.keymaps.set("q", jira.cmd.quit, "Quit")
jira.keymaps.set("<ESC>", jira.cmd.quit)

jira.keymaps.set("F", jira.cmd.refresh_all, "Refresh all", "Sprint")

-- PBI LIST
jira.keymaps.set("/", jira.cmd.open_filter, "Filter", "PbiList")
jira.keymaps.set("F", jira.cmd.refresh_all, "Refresh all", "PbiList")

-- PBI
jira.keymaps.set("r", jira.cmd.open_raw_pbi_json, "Raw Json", "Pbi")
jira.keymaps.set("f", jira.cmd.refresh, "Refresh line", "Pbi")
jira.keymaps.set("o", jira.cmd.open_in_browser, "Browser", "Pbi")
