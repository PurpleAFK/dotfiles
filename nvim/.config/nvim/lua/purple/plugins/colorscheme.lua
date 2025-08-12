-- return {
-- 	--  "catppuccin/nvim",
-- 	--  name = "catppuccin",
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	-- "ellisonleao/gruvbox.nvim",
-- 	-- name = "gruvbox",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd("colorscheme rose-pine")
-- 	end,
-- }

return {
	"AlphaTechnolog/pywal.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- Set up pywal and load the colors
		require("pywal").setup()
	end,
}
