vim.opt.relativenumber = true
-- TEST
-- Telescope
vim.keymap.set("n", "<leader>sb", require("telescope.builtin").buffers, { desc = "[S]earch [B]uffers" })
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps, { desc = "[S]earch [K]eymaps" })

vim.keymap.set("n", "<leader>l", require("lazy").sync, { desc = "[L]azy" })
vim.opt.foldnestmax = 3
vim.opt.foldmethod = "indent"

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.tex",
	callback = function()
		if vim.fn.executable("make") == 1 then
			vim.fn.jobstart("make", {
				detach = true,
				on_stdout = function(_, data)
					local output = {}
					if data then
						local i = 1
						while i <= #data do
							local line = data[i]
							if
								(line:match("^!") or line:match("[Ee]rror "))
								and (not line:match("There was 1 error message"))
							then
								-- Add the matching line and the next two lines (if they exist) to the output
								table.insert(output, line)
								if i + 1 <= #data then
									table.insert(output, data[i + 1])
								end
								if i + 2 <= #data then
									table.insert(output, data[i + 2])
								end
								i = i + 2 -- Skip to after the extra lines to avoid redundant matching
							end
							i = i + 1
						end
					end
					if #output > 0 then
						vim.api.nvim_echo({ { table.concat(output, "\n"), "Normal" } }, true, {})
					end
				end,
				on_stderr = function(_, data)
					local output = {}
					if data then
						local i = 1
						while i <= #data do
							local line = data[i]
							if line:match("^!") or line:match("[Ee]rror ") then
								-- Add the matching line and the next two lines (if they exist) to the output
								table.insert(output, line)
								if i + 1 <= #data then
									table.insert(output, data[i + 1])
								end
								if i + 2 <= #data then
									table.insert(output, data[i + 2])
								end
								i = i + 2 -- Skip to after the extra lines to avoid redundant matching
							end
							i = i + 1
						end
					end
					if #output > 0 then
						vim.api.nvim_echo({ { table.concat(output, "\n"), "ErrorMsg" } }, true, {})
					end
				end,
			})
		end
	end,
})

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
