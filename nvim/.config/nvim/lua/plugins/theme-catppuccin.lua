return {
	"catppuccin/nvim",
	name = "theme",
	lazy = false,
	priority = 999,
	config = function()
		require("catppuccin").setup({})
	end,
}
