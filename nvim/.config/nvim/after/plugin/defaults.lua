vim.opt.relativenumber = true
-- TEST
-- Telescope
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch [B]uffers" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })

vim.keymap.set("n", "<leader>l", require("lazy").sync, { desc = "[L]azy" })
vim.opt.foldnestmax = 3
vim.opt.foldmethod = "indent"

require("lspconfig").clangd.setup({
	cmd = { "clangd" }, -- Specify the clangd binary
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_dir = require("lspconfig").util.root_pattern("compile_commands.json", "CMakeLists.txt", ".git"),
})

vim.api.nvim_set_keymap("n", "<leader>1", "1gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>2", "2gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>3", "3gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>4", "4gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>5", "5gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>6", "6gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>7", "7gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>8", "8gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>9", "9gt", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>0", ":tablast<CR>", { noremap = true, silent = true })
local warnings_enabled = true
local function toggle_warnings()
	warnings_enabled = not warnings_enabled
	if warnings_enabled then
		print("Warnings enabled")
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
		})
	else
		print("Warnings disabled")
		vim.diagnostic.config({
			severity_sort = true,
			float = {
				severity = {
					min = vim.diagnostic.severity.ERROR,
				},
			},
			virtual_text = {
				severity = {
					min = vim.diagnostic.severity.ERROR,
				},
			},
			signs = {
				severity = {
					min = vim.diagnostic.severity.ERROR,
				},
			},
			underline = {
				severity = {
					min = vim.diagnostic.severity.ERROR,
				},
			},
		})
	end
end

vim.api.nvim_create_user_command(
	"ToggleWarnings", -- Name of the command
	function()
		toggle_warnings()
	end, -- Call the function
	{} -- Options (e.g., nargs for arguments, bang for `!` modifier, etc.)
)

-- Keymap to toggle warnings with <leader>tw
vim.api.nvim_set_keymap("n", "<leader>tw", "<cmd>ToggleWarnings<CR>", { noremap = true, silent = true })

-- Add the plugin configuration here in after/plugin/defaults.lua

require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, desc, opts)
			opts = opts or {}
			opts.buffer = bufnr
			opts.desc = desc
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, "Go to next Git hunk")

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, "Go to previous Git hunk")

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Git hunk")
		map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Git hunk")

		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Stage selected Git hunk")

		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "Reset selected Git hunk")

		map("n", "<leader>hS", gitsigns.stage_buffer, "Stage entire buffer")
		map("n", "<leader>hR", gitsigns.reset_buffer, "Reset entire buffer")
		map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Git hunk")
		map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Preview Git hunk inline")

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, "Show blame for current line")

		map("n", "<leader>hd", gitsigns.diffthis, "Diff against index")

		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, "Diff against last commit")

		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end, "Add all hunks to quickfix list")

		map("n", "<leader>hq", gitsigns.setqflist, "Add current buffer hunks to quickfix list")

		-- Toggles
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle inline blame")
		map("n", "<leader>td", gitsigns.toggle_deleted, "Toggle deleted lines")
		map("n", "<leader>tw", gitsigns.toggle_word_diff, "Toggle word diff")

		-- Text object
		map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Git hunk")
	end,
})
vim.opt.colorcolumn = "80"
vim.cmd("highlight ColorColumn guibg=#2E2E2E")

vim.keymap.set("n", "<leader>tl", function()
	if vim.inspect(vim.opt.colorcolumn:get()) == "{}" then
		vim.opt.colorcolumn = "80"
	else
		vim.opt.colorcolumn = ""
	end
	vim.cmd([[highlight ColorColumn ctermbg=lightgrey guibg=lightgrey]])
end, { desc = "Toggle Line Length Indicator" })

vim.opt.wrap = true
