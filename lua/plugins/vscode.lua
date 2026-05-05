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

-- mini.nvim
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.ai").setup()

local minisurround = require("mini.surround")
minisurround.setup({
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsc", -- Replace surrounding
  },
})

require("mini.pairs").setup({ modes = { command = true } })

-- Insert `<>` pair if `<` is typed at line start, don't register for <CR>
MiniPairs.map("i", "<", {
  action = "open",
  pair = "<>",
  neigh_pattern = "\r.",
  register = { cr = false },
})

MiniPairs.map("i", ">", { action = "close", pair = "<>", register = { cr = false } })

-- Create symmetrical `$$` pair only in Tex files
vim.api.nvim_create_autocmd("FileType", {
  group = Config.augr,
  pattern = "tex",
  callback = function()
    MiniPairs.map_buf(0, "i", "$", { action = "closeopen", pair = "$$" })
  end,
})

-- im-select.nvim
-- NOTE: make sure macism is installed
if Config.profile_is_default and vim.fn.has("mac") == 1 then
  vim.pack.add({ "https://github.com/keaising/im-select.nvim" })

  require("im_select").setup({
    default_im_select = "com.apple.keylayout.US",
    default_command = "macism",
    set_default_events = { "InsertLeave", "CmdlineLeave", "FocusGained" },
    set_previous_events = { "InsertEnter" },
    async_switch_im = true,
  })
end

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
      default = {
        augend.integer.alias.decimal, -- nonnegative decimal number
        augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
        augend.integer.alias.hex, -- nonnegative hex number
        augend.constant.alias.bool, -- boolean value (true <-> false)
        augend.constant.alias.Bool,
        augend.constant.alias.en_weekday, -- Mon, Tue, ..., Sat, Sun
        augend.constant.alias.en_weekday_full,
        augend.semver.alias.semver, -- semantic versions
        -- date (2022/02/19, etc.)
        augend.date.new({
          pattern = "%Y/%m/%d",
          default_kind = "day",
        }),
        augend.hexcolor.new({
          case = "prefer_upper",
        }),
      },
    })
    require("dial.config").augends:on_filetype({
      markdown = {
        augend.integer.alias.decimal,
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.constant.alias.en_weekday,
        augend.constant.alias.en_weekday_full,
        augend.semver.alias.semver,
        augend.date.new({
          pattern = "%Y/%m/%d",
          default_kind = "day",
        }),
        augend.constant.new({
          elements = { "[ ]", "[x]" },
          word = false,
          cyclic = true,
        }),
        augend.misc.alias.markdown_header,
      },
      fn(),
    })
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
