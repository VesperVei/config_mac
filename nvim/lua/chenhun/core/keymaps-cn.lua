local keymap = vim.keymap.set

-- ======================
-- General（通用）
-- ======================
keymap("i", "jk", "<ESC>", { desc = "退出插入模式（jk）" })

keymap("n", "<leader>nh", ":nohl<CR>", { desc = "清除搜索高亮" })

keymap("n", "<leader>+", "<C-a>", { desc = "数字加一" })
keymap("n", "<leader>-", "<C-x>", { desc = "数字减一" })

keymap("n", "<leader>sv", "<C-w>v", { desc = "垂直分屏" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "水平分屏" })
keymap("n", "<leader>se", "<C-w>=", { desc = "均分窗口大小" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "关闭当前分屏" })

-- ======================
-- Tabs（标签页）
-- ======================
keymap("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "新建标签页" })
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "关闭当前标签页" })
keymap("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "下一个标签页" })
keymap("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "上一个标签页" })
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "当前文件在新标签页打开" })

-- ======================
-- Auto Session（会话管理）
-- ======================
keymap("n", "<leader>wr", "<cmd>SessionRestore<CR>", {
	desc = "恢复当前目录的会话",
})

keymap("n", "<leader>ws", "<cmd>SessionSave<CR>", {
	desc = "保存当前工作区会话",
})

-- ======================
-- File Explorer（文件树）
-- ======================

keymap("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", {
	desc = "切换文件树显示",
})

keymap("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", {
	desc = "在文件树中定位当前文件",
})

keymap("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", {
	desc = "折叠文件树",
})

keymap("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", {
	desc = "刷新文件树",
})

-- ======================
-- Search / Telescope（搜索）
-- ======================
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {
	desc = "模糊查找当前目录下的文件",
})

keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {
	desc = "查找最近打开的文件",
})

keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", {
	desc = "在当前目录中搜索字符串",
})

keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", {
	desc = "搜索光标下的字符串",
})

keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", {
	desc = "查找待办事项（TODO）",
})

-- ======================
-- TODO Comments（待办跳转）
-- ======================
keymap("n", "]t", function()
	require("todo-comments").jump_next()
end, {
	desc = "跳转到下一个 TODO",
})

keymap("n", "[t", function()
	require("todo-comments").jump_prev()
end, {
	desc = "跳转到上一个 TODO",
})

-- ======================
-- Substitute（快速替换）
-- ======================

keymap("n", "s", require("substitute").operator, {
	desc = "按动作替换文本",
})

keymap("n", "ss", require("substitute").line, {
	desc = "替换当前行",
})

keymap("n", "S", require("substitute").eol, {
	desc = "替换至行尾",
})

keymap("x", "s", require("substitute").visual, {
	desc = "在可视模式下替换",
})

-- ======================
-- Git UI（LazyGit
--=====================

keymap("n", "<leader>lg", "<cmd>LazyGit<cr>", {
	desc = "打开 LazyGit",
})

-- ======================
-- Trouble（诊断面板）
-- ======================

keymap("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", {
	desc = "显示工作区诊断信息",
})

keymap("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", {
	desc = "显示当前文件诊断信息",
})

keymap("n", "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", {
	desc = "显示 Quickfix 列表",
})

keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", {
	desc = "显示位置列表（Loclist）",
})

keymap("n", "<leader>xt", "<cmd>Trouble todo toggle<CR>", {
	desc = "在 Trouble 中显示 TODO",
})

-- ======================
-- Window Layout（窗口布局）
-- ======================
-- 强制加载maximizer插件
require("lazy").load({ plugins = { "vim-maximizer" } })

keymap("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", {
	desc = "最大化 / 还原当前窗口",
})
