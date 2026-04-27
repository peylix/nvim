local map = vim.keymap.set

-- mini.nvim
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Set up to not prefer extension-based icon for some extensions
local ext3_blocklist = { scm = true, txt = true, yml = true }
local ext4_blocklist = { json = true, yaml = true }
require("mini.icons").setup({
  use_file_extension = function(ext, _)
    return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
  end,
})

-- Mock mock_nvim_web_devicons
require("mini.icons").mock_nvim_web_devicons()

require("mini.files").setup({
  windows = {
    preview = true,
  },
})

map("n", "<leader>ed", "<lmd>lua MiniFiles.open()<CR>", { desc = "Directory" })
map(
  "n",
  "<leader>ee",
  "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>",
  { desc = "File directory" }
)

local minitrailspace = require("mini.trailspace")
minitrailspace.setup()
vim.api.nvim_create_user_command("TrimWhitespace", MiniTrailspace.trim, {
  desc = "Trim trailing whitespace from all lines in the current buffer using Mini.Trailspace",
})
vim.api.nvim_create_user_command("TrimLastLine", MiniTrailspace.trim_last_lines, {
  desc = "Trim last lines that are empty or contain only whitespace using Mini.Trailspace",
})

-- set color for trailing whitespace and ensure it stays the same across colorschemes
local trailspace_color = "#4C1036"
vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = trailspace_color })
Config.create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = trailspace_color })
  end,
})

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

require("mini.cursorword").setup()

local miniclue = require("mini.clue")
  -- stylua: ignore
  miniclue.setup({
    -- Define which clues to show. By default shows only clues for custom mappings
    -- (uses `desc` field from the mapping; takes precedence over custom clue).
    window = {
        delay = 0,
    },
    clues = {
      -- This is defined in 'keymaps.lua' with Leader group descriptions
      Config.leader_group_clues,
      Config.localleader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      -- This creates a submode for window resize mappings. Try the following:
      -- - Press `<C-w>s` to make a window split.
      -- - Press `<C-w>+` to increase height. Clue window still shows clues as if
      --   `<C-w>` is pressed again. Keep pressing just `+` to increase height.
      --   Try pressing `-` to decrease height.
      -- - Stop submode either by `<Esc>` or by any key that is not in submode.
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    -- Explicitly opt-in for set of common keys to trigger clue window
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' }, -- Leader triggers
      { mode = { 'n', 'x' }, keys = '<localleader>' }, -- Leader triggers
      { mode =   'n',        keys = '\\' },       -- mini.basics
      { mode = { 'n', 'x' }, keys = ']' },
      { mode =   'i',        keys = '<C-x>' },    -- Built-in completion
      { mode = { 'n', 'x' }, keys = 'g' },        -- `g` key
      { mode = { 'n', 'x' }, keys = "'" },        -- Marks
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' },        -- Registers
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode =   'n',        keys = '<C-w>' },    -- Window commands
      { mode = { 'n', 'x' }, keys = 'z' },        -- `z` key
    },
  })

require("mini.starter").setup({
  header = table.concat({
    "                                ",
    "▗▄▄▖ ▗▄▄▄▖▗▖  ▗▖▗▖   ▗▄▄▄▖▗▖  ▗▖",
    "▐▌ ▐▌▐▌    ▝▚▞▘ ▐▌     █   ▝▚▞▘ ",
    "▐▛▀▘ ▐▛▀▀▘  ▐▌  ▐▌     █    ▐▌  ",
    "▐▌   ▐▙▄▄▖  ▐▌  ▐▙▄▄▖▗▄█▄▖▗▞▘▝▚▖",
    "                                ",
    "▗▖  ▗▖▗▖  ▗▖▗▄▄▄▖▗▖  ▗▖         ",
    "▐▛▚▖▐▌▐▌  ▐▌  █  ▐▛▚▞▜▌         ",
    "▐▌ ▝▜▌▐▌  ▐▌  █  ▐▌  ▐▌         ",
    "▐▌  ▐▌ ▝▚▞▘ ▗▄█▄▖▐▌  ▐▌         ",
    "                                ",
  }, "\n"),
  footer = "Have a nice day!",
})

require("mini.sessions").setup({
  autoread = true,
  autowrite = true,
})

local session_new = 'vim.ui.input({ prompt = "Session name: " }, MiniSessions.write)'

map("n", "<leader>sd", '<cmd>lua MiniSessions.select("delete")<CR>', { desc = "Delete" })
map("n", "<leader>sn", "<cmd>lua " .. session_new .. "<CR>", { desc = "New" })
map("n", "<leader>sr", '<cmd>lua MiniSessions.select("read")<CR>', { desc = "Read" })
map("n", "<leader>sR", "<cmd>lua MiniSessions.restart()<CR>", { desc = "Restart" })
map("n", "<leader>sw", "<cmd>lua MiniSessions.write()<CR>", { desc = "Write current" })

require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "┃", change = "┃", delete = "┃" },
  },
  map(
    "n",
    "<leader>gd",
    "<cmd>lua MiniDiff.toggle_overlay()<CR>",
    { desc = "Toggle diff overlay" }
  ),
})
