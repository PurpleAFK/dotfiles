return {
	--  "catppuccin/nvim",
	--  name = "catppuccin",
	"rose-pine/neovim",
	name = "rose-pine",
	-- "ellisonleao/gruvbox.nvim",
	-- name = "gruvbox",
	priority = 1000,
	config = function()
		vim.cmd("colorscheme rose-pine")
	end,
}
