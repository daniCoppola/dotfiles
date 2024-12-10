vim.opt.relativenumber = true

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

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "tex",  -- Apply only to LaTeX files
--     callback = function()
--         vim.opt_local.foldmethod = "expr"
--         vim.opt_local.foldexpr = "v:lua.LaTeXFoldExpr()"
--         vim.opt_local.foldnestmax = 5
--         -- Define the LaTeX fold expression function
--         function LaTeXFoldExpr()
--             local line = vim.fn.getline(vim.v.lnum)  -- Get the current line text
--
--             print("Function")  -- D
--             -- Define fold levels based on LaTeX sectioning commands
--             if line:match("^\\chapter") then
--                 return "1"
--             elseif line:match("^\\section") then
--                 return "2"
--             elseif line:match("^\\subsection") then
--                 return "3"
--             elseif line:match("^\\subsubsection") then
--                 return "4"
--             elseif line:match("^\\paragraph") then
--                 return "5"
--             elseif line:match("^\\subparagraph") then
--                 return "6"
--             else
--                 return "="  -- Do not change fold level for other lines
--             end
--         end
--           vim.opt_local.foldtext = [[
--             local fold_lines = {}
--             -- Iterate over all lines in the fold range
--             for i = v:foldstart + 1, v:foldend do
--                 -- Check if the line has a lower fold level than the current fold
--                 if vim.fn.foldlevel(i) > vim.fn.foldlevel(v:foldstart) then
--                     -- Add the first line of the lower-level fold
--                     table.insert(fold_lines, getline(i))
--                 end
--             end
--
--             -- Number of folded lines
--             local fold_count = v:foldend - v:foldstart
--
--             -- If there are any lower folds, join them with a separator
--             if #fold_lines > 0 then
--                 return getline(v:foldstart) .. ' --> ' .. table.concat(fold_lines, ', ') .. ' (' .. fold_count .. ' more lines)'
--             else
--                 return getline(v:foldstart) .. ' (' .. fold_count .. ' more lines)'
--             end
--         ]]
--
--
--     end,
-- })
--
