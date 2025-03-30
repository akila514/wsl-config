require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
  },

  -- Enable format on save with options
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- Auto-format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- Optional: Manually trigger formatting with <Leader>f
vim.api.nvim_set_keymap('n', '<Leader>f', ':lua require("conform").format()<CR>', { noremap = true, silent = true })
