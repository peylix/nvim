local map = vim.keymap.set

-- Paste linewise before or after current line
map("n", "[p", '<cmd>exe "iput! " . v:register<CR>', { desc = "Paste Above" })
map("n", "]p", '<cmd>exe "iput " . v:register<CR>', { desc = "Paste Below" })

-- Move to the end of the line if this is the last line
map({ "n", "x" }, "j", function()
  return vim.fn.line(".") == vim.fn.line("$") and "$" or "j"
end, { expr = true, noremap = true, desc = "Move to EOL on last line, else move down" })

-- Move to the beginning of the line if this is the first line
map({ "n", "x" }, "k", function()
  return vim.fn.line(".") == 1 and "0" or "k"
end, { expr = true, noremap = true, desc = "Move to BOL on first line, else move up" })

-- Remapping keybindings for moving to the end of line
map({ "n", "x" }, "-", "$", { noremap = true, desc = "Move to end of line" })

-- <leader>/ for commenting the current line or the selected area
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })

-- Clear search highlights after pressing <Esc>
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })

-- Window related operations
map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Left window" })
map({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Down window" })
map({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Up window" })
map({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Right window" })

map("n", "|", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "\\", "<cmd>split<CR>", { desc = "Horizontal split" })

-- Use tab for indent
map("v", "<Tab>", ">gv", { noremap = true, silent = true, desc = "Indent selection" })
map("v", "<S-Tab>", "<gv", { noremap = true, silent = true, desc = "Outdent selection" })

-- Close buffer
map(
  "n",
  "<leader>c",
  "<cmd>bdelete<CR>",
  { noremap = true, silent = true, desc = "Close buffer" }
)

-- Back to normal mode in terminal
map("t", "<C-Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Restart Neovim
map(
  "n",
  "<leader>or",
  "<cmd>restart<CR>",
  { noremap = true, silent = true, desc = "Restart Neovim" }
)

-- Yank the entire buffer
local function yank_entire_buffer()
  vim.cmd("%y+")
  local lines = vim.api.nvim_buf_line_count(0)
  vim.notify(("Yanked %d lines"):format(lines))
end

map("n", "<leader>oy", yank_entire_buffer, {
  desc = "Yank entire buffer",
})

Config.leader_group_clues = {
  { mode = "n", keys = "<leader>a", desc = "+AI" },
  { mode = "n", keys = "<leader>b", desc = "+Buffer" },
  { mode = "n", keys = "<leader>e", desc = "+Explore" },
  { mode = "n", keys = "<leader>f", desc = "+Find" },
  { mode = "n", keys = "<leader>g", desc = "+Git" },
  { mode = "n", keys = "<leader>l", desc = "+Language" },
  { mode = "n", keys = "<leader>o", desc = "+Other" },
  { mode = "n", keys = "<leader>s", desc = "+Session" },
  { mode = "n", keys = "<leader>t", desc = "+Terminal" },
}

Config.localleader_group_clues = {
  { mode = "n", keys = "<localleader>l", desc = "+VimTex" },
}

-- Toggle quickfix/localfix list
map("n", "<leader>oq", function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen")
end, { desc = "Quickfix list" })
map("n", "<leader>ol", function()
  vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen")
end, { desc = "Location list" })

-- Language related
map("n", "<leader>lf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format this buffer" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = Config.augr,
  callback = function(args)
    local opts = { buffer = args.buf, desc = "LSP Rename Symbol" }
    map("n", "<leader>lr", vim.lsp.buf.rename, opts)
  end,
})
