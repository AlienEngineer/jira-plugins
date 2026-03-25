# Configurations & plugins for Jira

Jira tool can be found here: [Jira](https://github.com/AlienEngineer/jira)

This repo hold custom configurations in lua for the jira command line tool.

## installation

```bash
# save current configuration
mv ~/.config/jira{,.bak}

git clone https://github.com/AlienEngineer/jira-plugins ~/.config/jira
```

## files

- init.lua
  - contains information about what can be accessed in lua scripts.
- keymaps.lua
  - default keymaps such as navigation, open ticket in browser, etc
- start_work.lua
  -  <CR> keymap for automate start a pbi (assign to me, change status to "In Progress", refresh item)

