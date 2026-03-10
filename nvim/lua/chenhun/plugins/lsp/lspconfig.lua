return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- ✅ 1. 导入你的虚拟环境管理模块
		local python_venv = require("chenhun.core.python_venv")

		local keymap = vim.keymap

		-- ========== LSP Keymaps (保持你原有的配置) ==========
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- ========== Diagnostic Icons (保持不变) ==========
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- 像 VSCode 一样在行尾显示诊断信息（LSP 与 nvim-lint 共用）
		vim.diagnostic.config({
			virtual_text = {
				spacing = 2,
				source = "if_many",
				prefix = "●",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "if_many",
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"emmet_ls",
				"graphql",
				"svelte",
				"bashls",
				"jsonls",
				"html",
				"ts_ls",
				"pyright",
			},
			automatic_installation = true,
		})

		-- ========== ✅ 2. 自定义 LSP 处理函数 ==========
		local handlers = {
			-- 默认处理
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			-- ✅ Pyright 核心适配：动态识别 venv
			["pyright"] = function()
				lspconfig.pyright.setup({
					capabilities = capabilities,
					on_new_config = function(new_config, _)
						local python_venv = require("chenhun.core.python_venv")
						local current = python_venv.get_current_venv()
						local venv_base = "/Users/zaochuan/Documents/code/python/.venvs"

						if current then
							-- 1. 补全用的路径
							new_config.settings.python.pythonPath = venv_base .. "/" .. current .. "/bin/python"
							-- 2. ✅ 诊断/报错消除用的路径
							new_config.settings.python.venvPath = venv_base
							new_config.settings.python.venv = current
						else
							new_config.settings.python.pythonPath =
								"/Library/Frameworks/Python.framework/Versions/3.13/bin/python3"
							new_config.settings.python.venvPath = nil
							new_config.settings.python.venv = nil
						end
					end,
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
							},
						},
					},
				})
			end,

			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							completion = { callSnippet = "Replace" },
						},
					},
				})
			end,
		}

		-- 启用的 LSP 列表
		local servers = {
			"lua_ls",
			"ts_ls",
			"pyright",
			"html",
			"cssls",
			"graphql",
			"emmet_ls",
			"svelte",
			"bashls",
			"jsonls",
		}

		for _, server_name in ipairs(servers) do
			if handlers[server_name] then
				handlers[server_name]()
			else
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end
		end
	end,
}
