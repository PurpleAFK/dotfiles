return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "dev",
				path = "~/vault/",
			},
			{
				name = "personal",
				path = "~/notes/",
			},
		},
		picker = {
			name = "telescope.nvim",
			mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
		},
		-- disable default frontmatter
		disable_frontmatter = true,
		-- Use title as filename instead of timestamp
		note_id_func = function(title)
			if title ~= nil then
				return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
			else
				return tostring(os.time())
			end
		end,
		new_notes_location = "notes_subdir",
		notes_subdir = "inbox",
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			template = "daily.md",
		},
		ui = {
			enable = false,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
			},
		},
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
			["<leader>ob"] = {
				action = function()
					vim.cmd("ObsidianBacklinks")
				end,
				opts = { buffer = true, desc = "Show backlinks" },
			},
			["<leader>ol"] = {
				action = function()
					vim.cmd("ObsidianLinks")
				end,
				opts = { buffer = true, desc = "Show outgoing links" },
			},
			-- Add tag search mapping
			["<leader>ot"] = {
				action = function()
					vim.cmd("ObsidianTags")
				end,
				opts = { buffer = true, desc = "Search by tags" },
			},
		},
		templates = {
			folder = "templates",
			date_format = "%a-%d-%m-%Y",
			time_format = "%H:%M",
			substitutions = {
				yesterday = function()
					return os.date("%Y-%m-%d", os.time() - 86400)
				end,
				tomorrow = function()
					return os.date("%Y-%m-%d", os.time() + 86400)
				end,
			},
		},
	},
}
