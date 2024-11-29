local opts = {
	ensure_installed = {
		"efm",
		"bashls",
		"solidity",
		"tailwindcss",
		"pyright",
		-- "lua_ls",
		"emmet_ls",
		"jsonls",
		"clangd",
		"gopls",
	},

	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
