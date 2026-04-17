local map = vim.keymap.set

-- lualine.nvim
vim.pack.add({
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
})

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return " " .. table.concat(names, ", ")
end

-- use mini.icons instead of nvim-web-devicons
-- ensure mini.icons is enabled before this plugin.
require("mini.icons").mock_nvim_web_devicons()

require("lualine").setup({
  sections = {
    lualine_x = {
      lsp_clients,
      "encoding",
      "fileformat",
      "filetype",
    },
  },
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
