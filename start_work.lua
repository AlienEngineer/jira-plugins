local function jira_print(msg)
	jira.cmd.print(msg)
end

local function assign_to_me(pbi)
	local account_id = jira_context.config.account_id
	if account_id == "" then
		jira_print("error: account-id not set in config")
		return
	end

	jira.cmd.assign_pbi(pbi.key, account_id)

	jira_print("assigned " .. pbi.key .. " to current user")
end

local function change_pbi_status(pbi, status)
	jira.cmd.change_pbi_status(pbi.key, status)

	jira_print("transitioned " .. pbi.key .. " to '" .. status .. "'")
end

-- Enter to start work (runs plugins)
local function start_work()
	local pbi = jira_context.selected_pbi
	if not pbi then
		jira_print("error: no PBI selected")
		return
	end

	assign_to_me(pbi)
	local status = jira_context.config.alias["ip"] or "In Progress"
	change_pbi_status(pbi, status)
	jira.cmd.refresh()
end

jira.keymaps.set("<CR>", start_work, "Start", "Sprint")
