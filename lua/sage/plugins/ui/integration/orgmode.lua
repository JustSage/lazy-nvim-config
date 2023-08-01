return {
	"nvim-orgmode/orgmode",
	event = "VeryLazy",
	ft = "org",
	config = function()
		require("orgmode").setup({
			mappings = {
				org = { org_cycle = "<nop>" },
				global = {
					org_agenda = "<Leader>oa",
					org_capture = "<Leader>oc",
				},
				capture = {
					org_capture_show_help = "gh"
				}
			},
			org_agenda_files = "~/Sync/org/**/*",
			org_default_notes_file = "~/Sync/org/inbox.org",
			org_deadline_warning_days = 5,
			org_agenda_start_on_weekday = 7,
			org_agenda_templates = {
				t = {
					description = "Todo",
					template = "* TODO %?\n %f\n %u",
					target = "~/Sync/org/inbox.org",
				},
				n = {
					description = "Note",
					template = "** %f\n%?SCHEDULED: %t\n\n",
					target = "~/Sync/org/notes.org",
				},
				e = "Event",
				er = {
					description = "Recurring Event",
					template = "** %?\n %T",
					target = "~/Sync/org/inbox.org",
					headline = "Recurring",
				},
				eo = {
					description = "One-Time Event",
					template = "** %?\n %T",
					target = "~/Sync/org/inbox.org",
					headline = "Event",
				},
				p = "Project",
				pt = {
					description = "Project Task",
					template = "**%<%d-%m-%Y>\nSCHEDULED: %t\n:LOGBOOK:\nCLOCK: %U\n%?\n",
					target = "~/Sync/org/projects/inbox.org",
					headline = "Projects"
				},
				pn = {
					description = "Project Note",
					template = "**%<%d-%m-%Y>\nSCHEDULED: %t\n:LOGBOOK:\nCLOCK: %U\n%?\n",
					target = "~/Sync/org/projects/inbox.org",
					headline = "Projects"
				},
				j = {
					description = "Journal",
					template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
					target = "~/Sync/org/journal.org",
					headline = "Journal"
				},
			},
		})
	end,
}
