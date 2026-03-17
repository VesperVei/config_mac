return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "af", desc = "Select around function", mode = { "o", "x" } },
    { "if", desc = "Select inside function", mode = { "o", "x" } },
    { "ac", desc = "Select around class", mode = { "o", "x" } },
    { "ic", desc = "Select inside class", mode = { "o", "x" } },
    { "aa", desc = "Select around parameter", mode = { "o", "x" } },
    { "ia", desc = "Select inside parameter", mode = { "o", "x" } },
    { "]m", desc = "Next function start" },
    { "]M", desc = "Next function end" },
    { "[m", desc = "Previous function start" },
    { "[M", desc = "Previous function end" },
    { "]]", desc = "Next class start" },
    { "][", desc = "Next class end" },
    { "[[", desc = "Previous class start" },
    { "[]", desc = "Previous class end" },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    })
  end,
}
