local map = vim.keymap.set

-- lualine.nvim
vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
})

-- This is based on Eviline config for lualine
local lualine = require("lualine")

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#070c30',
  fg       = '#bbc2cf',
  white    = '#ffffff',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme.  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = "bold" },
      },
    },
    lualine_x = {
      {
        "location",
        color = { fg = colors.fg, gui = "bold" },
      },
    },
    lualine_y = {},
    lualine_z = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({
  function()
    local mode_map = {
      n = "NO", -- Normal mode
      no = "OP", -- Operator-pending mode
      nov = "OP",
      noV = "OP",
      ["no\22"] = "OP",

      i = "IN", -- Insert mode

      v = "VI", -- Visual charactor mode
      V = "VL", -- Visual line mode
      [""] = "VB", -- Visual block mode

      c = "CM", -- Command-line mode

      R = "RE", -- Replace mode
      Rv = "VR", -- Virtual replace

      s = "SE", -- Select mode
      S = "SL", -- Select line mode
      [""] = "SB", -- Select block mode

      t = "TE", -- Terminal mode
    }

    return mode_map[vim.fn.mode()] or "?"
  end,

  color = function()
    local mode_color = {
      n = colors.fg,
      no = colors.fg,
      nov = colors.fg,
      noV = colors.fg,
      ["no\22"] = colors.fg,

      i = colors.green,

      v = colors.magenta,
      V = colors.magenta,
      [""] = colors.magenta,

      c = colors.orange,

      R = colors.violet,
      Rv = colors.violet,

      s = colors.blue,
      S = colors.blue,
      [""] = colors.blue,

      t = colors.red,
    }

    return {
      fg = mode_color[vim.fn.mode()] or colors.fg,
      gui = "bold",
    }
  end,

  padding = { left = 1, right = 1 },
})

-- ins_left({
--   -- filesize component
--   "filesize",
--   cond = conditions.buffer_not_empty,
-- })

ins_left({
  function()
    local reg = vim.fn.reg_recording()
    if reg ~= "" then return "Recording @" .. reg end
    return ""
  end,
  color = { fg = colors.red, gui = "bold" },
})

ins_left({
  "filename",
  cond = conditions.buffer_not_empty,
  color = { fg = colors.blue, gui = "bold" },
})

ins_left({ "location" })

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left({
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    info = { fg = colors.cyan },
  },
})

-- Insert mid section
-- for lualine it's any number greater then 2
ins_left({
  function()
    return "%="
  end,
})

ins_left({
  -- Lsp server name
  function()
    local msg = "N/A"
    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then return msg end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then return client.name end
    end
    return msg
  end,
  icon = " ",
  color = { fg = colors.white, gui = "bold" },
})

ins_right({
  function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.treesitter.highlighter.active[bufnr] then return "TS" end
    return ""
  end,
  icon = "󰔱",
  color = { fg = colors.green, gui = "bold" },
})

-- Add components to right sections
ins_right({
  "o:encoding",
  fmt = string.upper,
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = "bold" },
})

-- ins_right({
--   "fileformat",
--   fmt = string.upper,
--   icons_enabled = false,
--   color = { fg = colors.green, gui = "bold" },
-- })

ins_right({
  "branch",
  icon = "",
  color = { fg = colors.violet, gui = "bold" },
})

ins_right({
  "diff",
  symbols = { added = " ", modified = "󰝤 ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
  padding = { right = 1 },
})

-- initialize lualine
lualine.setup(config)

vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  group = Config.augr,
  callback = function()
    local delay = vim.fn.mode() == "n" and 0 or 10
    vim.defer_fn(function()
      lualine.refresh()
    end, delay)
  end,
})

-- comfy-line-numbers.nvim
vim.pack.add({ "https://github.com/mluders/comfy-line-numbers.nvim" })

require("comfy-line-numbers").setup({
  labels = {
    "1",
    "2",
    "3",
    "8",
    "9",
    "11",
    "12",
    "13",
    "18",
    "19",
    "21",
    "22",
    "23",
    "28",
    "29",
    "31",
    "32",
    "33",
    "38",
    "39",
    "41",
    "42",
    "43",
    "48",
    "49",
    "111",
    "112",
    "113",
    "118",
    "119",
    "121",
    "122",
    "123",
    "128",
    "129",
    "131",
    "132",
    "133",
    "138",
    "139",
    "141",
    "142",
    "143",
    "148",
    "149",
    "211",
    "212",
    "213",
    "218",
    "219",
    "221",
    "222",
    "223",
    "228",
    "229",
    "231",
    "232",
    "233",
    "238",
    "239",
    "241",
    "242",
    "243",
    "248",
    "249",
  },
  up_key = "k",
  down_key = "j",

  -- Line numbers will be completely hidden for the following file/buffer types
  hidden_file_types = { "undotree" },
  hidden_buffer_types = { "terminal", "nofile" },
})

-- numb.nvim
vim.pack.add({ "https://github.com/nacro90/numb.nvim" })
require("numb").setup()

-- glance.nvim
vim.pack.add({ "https://github.com/dnlhc/glance.nvim" })
require("glance").setup()
map("n", "gD", "<CMD>Glance definitions<CR>")
map("n", "gR", "<CMD>Glance references<CR>")
map("n", "gY", "<CMD>Glance type_definitions<CR>")
map("n", "gM", "<CMD>Glance implementations<CR>")

-- modes.nvim
vim.pack.add({ "https://github.com/mvllow/modes.nvim" })
require("modes").setup()

-- render-markdown.nvim
vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})
require("render-markdown").setup({})

-- todo-comments.nvim
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/folke/todo-comments.nvim",
})

local todo_comments = require("todo-comments")

todo_comments.setup()

map("n", "]t", function()
  todo_comments.jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
  todo_comments.jump_prev()
end, { desc = "Previous todo comment" })

-- fidget.nvim
vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })
require("fidget").setup({
  notification = {
    override_vim_notify = true,
  },
})
