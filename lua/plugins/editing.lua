local map = vim.keymap.set

-- flash.nvim
local function flash(fn)
  return function()
    vim.pack.add({ "https://github.com/folke/flash.nvim" })
    require("flash").setup()
    fn()
  end
end

map(
  { "n", "x", "o" },
  "s",
  flash(function()
    require("flash").jump()
  end),
  { desc = "Flash" }
)

map(
  { "n", "x", "o" },
  "S",
  flash(function()
    require("flash").treesitter()
  end),
  { desc = "Flash Treesitter" }
)

map(
  "o",
  "r",
  flash(function()
    require("flash").remote()
  end),
  { desc = "Remote Flash" }
)

map(
  { "o", "x" },
  "R",
  flash(function()
    require("flash").treesitter_search()
  end),
  { desc = "Treesitter Search" }
)

map(
  "c",
  "<c-s>",
  flash(function()
    require("flash").toggle()
  end),
  { desc = "Toggle Flash Search" }
)

-- blink.cmp
vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/fang2hou/blink-copilot",

  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("*"),
  },
})

-- helper functions
local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
      == nil
end

local function get_mini_icon(ctx)
  if ctx.source_name == "Path" then
    local is_unknown_type = vim.tbl_contains(
      { "link", "socket", "fifo", "char", "block", "unknown" },
      ctx.item.data.type
    )
    local mini_icon, mini_hl, _ = require("mini.icons").get(
      is_unknown_type and "os" or ctx.item.data.type,
      is_unknown_type and "" or ctx.label
    )
    if mini_icon then return mini_icon, mini_hl end
  end
  local mini_icon, mini_hl, _ = require("mini.icons").get("lsp", ctx.kind)
  return mini_icon, mini_hl
end

require("blink.cmp").setup({
  keymap = {
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<C-N>"] = { "select_next", "show" },
    ["<C-P>"] = { "select_prev", "show" },
    ["<C-J>"] = { "select_next", "fallback" },
    ["<C-K>"] = { "select_prev", "fallback" },
    ["<C-U>"] = { "scroll_documentation_up", "fallback" },
    ["<C-D>"] = { "scroll_documentation_down", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = {
      "select_next",
      "snippet_forward",
      function(cmp)
        if has_words_before() or vim.api.nvim_get_mode().mode == "c" then
          return cmp.show()
        end
      end,
      "fallback",
    },
    ["<S-Tab>"] = {
      "select_prev",
      "snippet_backward",
      function(cmp)
        if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
      end,
      "fallback",
    },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
    accept = {
      auto_brackets = { enabled = true },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      window = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      },
    },
    menu = {
      draw = {
        treesitter = { "lsp" },
        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icon, kind_hl = get_mini_icon(ctx)
              return kind_icon
            end,
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl = get_mini_icon(ctx)
              return hl
            end,
          },
          kind = {
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl = get_mini_icon(ctx)
              return hl
            end,
          },
        },
      },
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer", "copilot" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
      },
    },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
})

-- nvim-spider
local function spider(fn)
  return function()
    vim.pack.add({ "https://github.com/chrisgrieser/nvim-spider" })
    require("spider").setup()
    fn()
  end
end

map(
  { "n", "o", "x" },
  "w",
  spider(function()
    require("spider").motion("w")
  end),
  { desc = "Next word start" }
)
map(
  { "n", "o", "x" },
  "e",
  spider(function()
    require("spider").motion("e")
  end),
  { desc = "Next word start" }
)
map(
  { "n", "o", "x" },
  "b",
  spider(function()
    require("spider").motion("b")
  end),
  { desc = "Next word start" }
)
map(
  { "n", "o", "x" },
  "ge",
  spider(function()
    require("spider").motion("ge")
  end),
  { desc = "Next word start" }
)

-- dial.nvim
local function dial(fn)
  return function()
    vim.pack.add({ "https://github.com/monaqa/dial.nvim" })
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      -- default augends used when no group name is specified
      default = {
        augend.integer.alias.decimal, -- nonnegative decimal number
        augend.integer.alias.hex, -- nonnegative hex number
        augend.constant.alias.bool, -- boolean value (true <-> false)
        -- date (2022/02/19, etc.)
        augend.date.new({
          pattern = "%Y/%m/%d",
          default_kind = "day",
        }),
      },
    })
    fn()
  end
end

map(
  "n",
  "<C-a>",
  dial(function()
    require("dial.map").manipulate("increment", "normal")
  end),
  { desc = "Increase this" }
)

map(
  "n",
  "<C-x>",
  dial(function()
    require("dial.map").manipulate("decrement", "normal")
  end),
  { desc = "Decrease this" }
)

map(
  "n",
  "g<C-a>",
  dial(function()
    require("dial.map").manipulate("increment", "gnormal")
  end),
  { desc = "Increase this" }
)

map(
  "n",
  "g<C-x>",
  dial(function()
    require("dial.map").manipulate("decrement", "gnormal")
  end),
  { desc = "Decrease this" }
)

map(
  "x",
  "<C-a>",
  dial(function()
    require("dial.map").manipulate("increment", "visual")
  end),
  { desc = "Increase this" }
)

map(
  "x",
  "<C-x>",
  dial(function()
    require("dial.map").manipulate("decrement", "visual")
  end),
  { desc = "Decrease this" }
)

map(
  "x",
  "g<C-a>",
  dial(function()
    require("dial.map").manipulate("increment", "gvisual")
  end),
  { desc = "Increase this" }
)

map(
  "x",
  "g<C-x>",
  dial(function()
    require("dial.map").manipulate("decrement", "gvisual")
  end),
  { desc = "Decrease this" }
)
