return {
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      render = "default",
      stages = "fade_in_slide_out",
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    cmd = { "Noice" },
    keys = {
      { "<leader>nn", "<cmd>Noice<CR>", desc = "Noice picker" },
      { "<leader>nl", "<cmd>Noice last<CR>", desc = "Noice last message" },
      { "<leader>na", "<cmd>Noice all<CR>", desc = "Noice all messages" },
      { "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Noice dismiss notifications" },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      views = {
        cmdline_popup = {
          position = {
            row = "50%",
            col = "50%",
          },
          size = {
            width = 60,
            height = "auto",
          },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            min_height = 12,
          },
          view = "split",
        },
        {
          filter = {
            event = "msg_show",
            kind = { "", "echo", "echomsg", "lua_print" },
          },
          view = "notify",
        },
        {
          filter = {
            event = "notify",
            min_height = 12,
          },
          view = "split",
        },
      },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = true },
        signature = { enabled = true },
        message = { enabled = true },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
    config = function(_, opts)
      require("noice").setup(opts)
      vim.notify = require("notify")
    end,
  },
}
