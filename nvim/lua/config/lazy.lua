-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.number = true
vim.opt.termguicolors = true

vim.diagnostic.config({
	virtual_text = true, -- Show errors inline
	signs = true, -- Show errors in the sign column
	underline = true, -- Underline errors
	update_in_insert = false, -- Don't update errors while typing
	severity_sort = true, -- Sort errors by severity
})

-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
	-- File Icons
	{ "nvim-tree/nvim-web-devicons", opts = {} },

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "angularls", "ts_ls" }, -- Use ts_ls instead of tsserver
			})
		end,
		dependencies = {
			"mason.nvim",
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			-- Setup Angular Language Server (angularls)
			lspconfig.angularls.setup({
				root_dir = lspconfig.util.root_pattern("angular.json"),
				settings = {
					angular = {
						languageService = {
							enable = true,
						},
					},
				},
			})

			-- Setup TypeScript Language Server (ts_ls)
			lspconfig.ts_ls.setup({
				root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json"),
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			})
		end,
		dependencies = {
			"mason-lspconfig.nvim",
			"mason.nvim",
		},
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({})
		end,
	},
	-- File Explorer (nvim-tree)
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			vim.opt.termguicolors = true
			require("nvim-tree").setup({
				sort = { sorter = "case_sensitive" },
				renderer = { group_empty = true },
				filters = { dotfiles = true },
				actions = {
					open_file = {
						quit_on_open = false, -- Close the tree when opening a file
						resize_window = true, -- Resize the window to fit the file
					},
				},
				git = {
					enable = true,
					ignore = false,
					timeout = 500,
				},
				view = {
					adaptive_size = true,
					width = 30,
					side = "left",
				},
				update_focused_file = {
					enable = true,
					update_cwd = true,
					ignore_list = {},
				},
				system_open = {
					cmd = nil,
					args = {},
				},
				diagnostics = {
					enable = true,
					show_on_dirs = true,
					icons = {
						hint = "",
						info = "",
						warning = "",
						error = "",
					},
				},
				trash = {
					cmd = "trash",
					require_confirm = true,
				},
				live_filter = {
					prefix = "[FILTER]: ",
					always_show_folders = false,
				},
			})
		end,
	},

	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({
				options = {
					numbers = "none", -- No numbers
					close_command = "bdelete! %d", -- Close buffer
					right_mouse_command = "bdelete! %d", -- Right-click close
					left_mouse_command = "buffer %d", -- Left-click switch
					middle_mouse_command = nil, -- Disable middle click close (optional)
					show_buffer_icons = true, -- Show file type icons
					show_buffer_close_icons = true, -- Show close button
					show_close_icon = false, -- Remove global close button
					show_tab_indicators = true, -- Show modified tabs
					enforce_regular_tabs = false, -- Keeps tabs flexible
					persist_buffer_sort = true, -- Keep sorting
					separator_style = "thin", -- "thin", "slant", "padded_slant", etc.
					diagnostics = "nvim_lsp", -- Show LSP diagnostics
					always_show_bufferline = true, -- Always visible
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "center",
							separator = true,
						},
					},
				},
				highlights = {
					fill = {
						fg = "#f5e0dc", -- Matches lualine’s c.fg
						bg = "#181825", -- Matches lualine’s c.bg
					},
					background = {
						fg = "#f5e0dc", -- Inactive tab text
						bg = "#1e1e2e", -- Inactive tab background
					},
					tab = {
						fg = "#f5e0dc",
						bg = "#313244",
					},
					tab_selected = {
						fg = "#cdd6f4", -- Active tab text
						bg = "#181825", -- Active tab background
					},
					buffer = {
						fg = "#f5e0dc",
						bg = "#1e1e2e",
					},
					buffer_visible = {
						fg = "#f5e0dc",
						bg = "#313244",
					},
					buffer_selected = {
						fg = "#cdd6f4", -- Selected buffer text
						bg = "#181825", -- Selected buffer background
						bold = true,
						italic = false,
					},
					separator = {
						fg = "#181825",
						bg = "#1e1e2e",
					},
					separator_selected = {
						fg = "#181825",
						bg = "#181825",
					},
					close_button = {
						fg = "#f5e0dc", -- Keep text color consistent with inactive buffers
						bg = "#1e1e2e", -- Set close button background to #181825
					},
					close_button_visible = {
						fg = "#f5e0dc",
						bg = "#1e1e2e", -- Consistent background for visible buffers
					},
					close_button_selected = {
						fg = "#cdd6f4", -- Match selected buffer text color
						bg = "#1e1e2e", -- Set close button background to #181825 for active buffer
					},
				},
			})
			vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true })
			vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })
		end,
	},
	-- Status Line (lualine)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = {
						normal = {
							a = { fg = "#cdd6f4", bg = "#181825" },
							b = { fg = "#f5e0dc", bg = "#313244" },
							c = { fg = "#f5e0dc", bg = "#181825" },
						},
						inactive = {
							a = { fg = "#cdd6f4", bg = "#1e1e2e" },
							b = { fg = "#f5e0dc", bg = "#313244" },
							c = { fg = "#f5e0dc", bg = "#1e1e2e" },
						},
					},
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = false,
					globalstatus = false,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {
					--	lualine_a = { "buffers" }, -- Shows opened buffers
					--	lualine_b = { "tabs" }, -- Tabs section
					--	lualine_c = { "filetype" },
				},
				winbar = {},
				inactive_winbar = {},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
	},

	-- Theme (VSCode)
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Neorg for notes
	{
		"nvim-neorg/neorg",
		lazy = false,
		version = "*",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
					["core.dirman"] = {
						config = {
							workspaces = {
								notes = "~/notes",
								istqb = "~/notes/istqb",
							},
							default_workspace = "notes",
						},
					},
				},
			})
			vim.wo.foldlevel = 99
			vim.wo.conceallevel = 2
		end,
	},

	-- Git Signs
	{ "lewis6991/gitsigns.nvim" },

	-- Treesitter setup
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"javascript",
					"typescript",
					"html",
					"css",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					disable = { "c", "rust" },
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
				},
			})
		end,
	},

	-- Comment plugin for code commenting
	{ "numToStr/Comment.nvim" },

	-- Autocompletion (nvim-cmp)
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},
})

-- Set up Catppuccin theme
require("catppuccin").setup({
	flavour = "auto", -- latte, frappe, macchiato, mocha
	background = { -- :h background
		light = "latte",
		dark = "mocha",
	},
	transparent_background = true, -- disables setting the background color.
	show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
	term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
	dim_inactive = {
		enabled = false, -- dims the background color of inactive window
		shade = "dark",
		percentage = 0.15, -- percentage of the shade to apply to the inactive window
	},
	no_italic = false, -- Force no italic
	no_bold = false, -- Force no bold
	no_underline = false, -- Force no underline
	styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
		comments = { "italic" }, -- Change the style of comments
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	color_overrides = {},
	custom_highlights = {},
	default_integrations = true,
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		treesitter = true,
		notify = false,
		mini = {
			enabled = true,
			indentscope_color = "",
		},
	},
})

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")
