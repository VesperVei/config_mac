-- lua/chenhun/core/colorscheme.lua

local status, tokyonight = pcall(require, "tokyonight")
if not status then
	return
end

local fg = "#CBE0F0"
local border = "#547998"
local bg_visual = "#275378"

tokyonight.setup({
	style = "night",
	transparent = true, -- 1. 开启官方透明支持
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
	on_colors = function(colors)
		-- 这里只负责定义“颜色数值”，千万不要写 "NONE"
		colors.border = border
		colors.fg = fg
		colors.bg_visual = bg_visual
	end,
	on_highlights = function(hl, c)
		-- 2. 在高亮组层面强制去掉背景色，这样不会触发插件内部的数学报错
		local comps = {
			"Normal",
			"NormalNC",
			"NormalFloat",
			"FloatBorder",
			"MsgArea",
			"NvimTreeNormal",
			"NvimTreeNormalNC",
			"TelescopeNormal",
			"TelescopeBorder",
			"SignColumn",
		}
		for _, comp in ipairs(comps) do
			hl[comp] = { bg = "NONE" }
		end
	end,
})

-- 启动主题
vim.cmd([[colorscheme tokyonight]])
