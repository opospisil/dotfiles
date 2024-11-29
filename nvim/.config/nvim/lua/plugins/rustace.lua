return {
  "mrcjkb/rustaceanvim",
  dependencies = {
    "rust-lang/rust.vim", -- Syntax highlighting and basic Rust support
  },
  version = "^5",
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        enable_clippy = true, -- Enable clippy checks on save
        hover_actions = {
          replace_builtin_hover = true, -- Replace the default hover with rust-specific actions
        },
        reload_workspace_from_cargo_toml = true, -- Reload the workspace when Cargo.toml changes
      },
      server = {
        cmd = { "/nix/store/8ky932dblp2vb2khjyhb92xwsy4ah859-rust-analyzer-2024-11-11/bin/rust-analyzer" }, -- Command to start the rust-analyzer LSP
        --cmd = { "/nix/store/8ky932dblp2vb2khjyhb92xwsy4ah859-rust-analyzer-2024-11-11/bin/rust-analyzer" }, -- Command to start the rust-analyzer LSP
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true, -- Enable all features for Cargo
            },
            checkOnSave = {
              command = "clippy", -- Run clippy instead of `cargo check` on save
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Add key mappings and buffer-local settings for Rust here
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Hover documentation
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- List references
        end,
      },
      dap = {
        autoload_configurations = true, -- Automatically load nvim-dap configurations
      },
    }
  end,
}
