-- =============================================================================
-- 模块：通用虚拟环境管理器 (当前针对 Python 优化)
-- 说明：负责路径更新、环境变量同步、状态栏显示及快捷键绑定
-- =============================================================================

vim.notify("[EnvManager] Python 模块加载成功")
local M = {}

-- =============================================================================
-- 1. 配置区 (按需修改以适配不同语言)
-- =============================================================================
local config = {
	-- 虚拟环境存放的根目录
	venv_root = "/Users/zaochuan/Documents/code/python/.venvs",
	-- 项目存放的根目录 (用于自动感应)
	project_root = "/Users/zaochuan/Documents/code/python",
	-- 系统默认的解释器路径
	default_bin = "/Library/Frameworks/Python.framework/Versions/3.13/bin/python3",
	-- 状态栏图标
	icon = "🐍 ",
}

-- 项目名 -> 虚拟环境名的特殊映射
local project_venv_map = {
	["AI"] = "robot",
}

-- 内部缓存
local cache = {
	venvs = nil, -- 扫描到的 venv 列表缓存
	current = nil, -- 当前选中的 venv 名称
}

-- =============================================================================
-- 2. 工具函数区
-- =============================================================================

-- 检查文件/目录是否存在
local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

-- 获取 venv 下的 bin 目录
local function get_venv_bin_dir(venv_name)
	return string.format("%s/%s/bin", config.venv_root, venv_name)
end

-- 移除 PATH 中所有来自 venv_root 的路径 (防止路径污染)
local function remove_venvs_from_path()
	local cur_path = vim.env.PATH or ""
	local parts = {}
	for part in string.gmatch(cur_path, "([^:]+)") do
		if not string.find(part, config.venv_root, 1, true) then
			table.insert(parts, part)
		end
	end
	vim.env.PATH = table.concat(parts, ":")
end

-- =============================================================================
-- 3. 核心逻辑区 (状态切换)
-- =============================================================================

-- 设置当前环境
function M.set_venv(venv_name)
	-- 情况 A：退出虚拟环境 (重置为系统默认)
	if not venv_name or venv_name == "" or venv_name == "system" then
		remove_venvs_from_path()
		vim.env.VIRTUAL_ENV = nil
		vim.g.python3_host_prog = config.default_bin
		cache.current = nil

		-- 重启所有 LSP 以便读取新的系统环境变量 (对所有 Python 监测工具生效)
		vim.cmd("LspRestart")
		vim.notify("🚫 已退出虚拟环境，使用系统解释器", vim.log.levels.INFO)
		return
	end

	-- 情况 B：进入指定的虚拟环境
	local venv_path = config.venv_root .. "/" .. venv_name
	local python_bin = venv_path .. "/bin/python"

	if not file_exists(python_bin) then
		vim.notify("错误：环境不存在 -> " .. python_bin, vim.log.levels.ERROR)
		return
	end

	-- 更新 Neovim 全局解释器
	vim.g.python3_host_prog = python_bin

	-- 更新环境变量 (这是让 nvim-lint/pylint 识别库的关键)
	vim.env.VIRTUAL_ENV = venv_path
	remove_venvs_from_path()
	vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH

	cache.current = venv_name

	-- 触发 LSP 重启
	vim.cmd("LspRestart")

	-- 刷新状态栏
	local ok, lualine = pcall(require, "lualine")
	if ok then
		lualine.refresh()
	end

	vim.notify(config.icon .. "已激活环境: " .. venv_name, vim.log.levels.INFO)
end

-- =============================================================================
-- 4. 交互界面 (菜单与自动感应)
-- =============================================================================

-- 弹出选择菜单
function M.choose_venv()
	-- 实时扫描 venv 目录
	local venvs = {}
	local p = io.popen('ls -1 "' .. config.venv_root .. '" 2>/dev/null')
	if p then
		for name in p:lines() do
			if name and #name > 0 then
				table.insert(venvs, name)
			end
		end
		p:close()
	end

	-- ✅ 优化：初始化为空表，仅显示搜索到的虚拟环境
	local choices = {}
	for _, v in ipairs(venvs) do
		table.insert(choices, config.icon .. v)
	end

	-- 如果没有发现任何环境，给出提示
	if #choices == 0 then
		vim.notify("未在 .venvs 目录下发现任何环境", vim.log.levels.WARN)
		return
	end

	vim.ui.select(choices, { prompt = "选择虚拟环境：" }, function(choice)
		if not choice then
			return
		end
		-- 直接执行环境切换
		M.set_venv(choice:gsub(config.icon, ""))
	end)
end

-- 自动匹配逻辑 (保持不变)
function M.autoset_venv()
	local cwd = vim.fn.getcwd()
	if not string.find(cwd, config.project_root, 1, true) then
		return
	end

	local project_name = cwd:match(config.project_root .. "/([^/]+)")
	if not project_name then
		return
	end

	local venv_name = project_venv_map[project_name] or project_name
	if file_exists(config.venv_root .. "/" .. venv_name .. "/bin/python") then
		if cache.current ~= venv_name then
			M.set_venv(venv_name)
		end
	end
end
-- =============================================================================
-- 5. UI 集成 (Lualine)
-- =============================================================================

function M.lualine_component()
	-- ✅ 要求 1：未启用时不显示任何内容 (包括 "system")
	if not cache.current or cache.current == "" then
		return ""
	end
	return config.icon .. cache.current
end

-- =============================================================================
-- 6. 快捷键与自动命令
-- =============================================================================

-- <leader>pv: 选择环境
vim.keymap.set("n", "<leader>pv", M.choose_venv, { desc = "Python: 选择环境" })

-- ✅ 要求 2：<leader>pr: 退出环境 (Reset)
vim.keymap.set("n", "<leader>pr", function()
	M.set_venv(nil)
end, { desc = "Python: 退出环境" })

-- 自动感应
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*.py",
	callback = function()
		M.autoset_venv()
	end,
})

return M
