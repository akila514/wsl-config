-- keymaps.lua
local builtin = require("telescope.builtin")

-- Telescope key mappings
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

--nvim-tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>", { desc = "Refresh NvimTree" })
vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>", { desc = "Find file in NvimTree" })
vim.keymap.set("n", "<leader>m", ":NvimTreeFocus<CR>", { desc = "Focus NvimTree" })
vim.keymap.set("n", "<leader>c", ":NvimTreeClose<CR>", { desc = "Close NvimTree" })
vim.keymap.set("n", "<leader>o", ":NvimTreeOpen<CR>", { desc = "Open NvimTree" })

--nvim-terminal
vim.keymap.set("n", "<leader>t", ":term<CR>", { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>ts", ":split | term<CR>", { desc = "Horizontal Split Terminal" })
vim.keymap.set("n", "<leader>td", ":vsplit | term<CR>", { desc = "Vertical Split Terminal" })

-- Close all buffers except the current one
vim.api.nvim_set_keymap("n", "<Leader>Q", ":%bd|e#|bd#<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<Leader>q", ":bdelete<CR>", { noremap = true, silent = true }) -- Close buffer

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search project with Telescope" })
