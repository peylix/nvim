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

-- Hide window
map(
  "n",
  "<leader>h",
  "<cmd>hide<CR>",
  { noremap = true, silent = true, desc = "Hide window" }
)


-- New terminal buffer
map("n", "<leader>tn", "<cmd>te<CR>", { desc = "New terminal" })

-- New terminal buffer in a horizontal split
map("n", "<leader>th", "<cmd>hor te<CR>", { desc = "New terminal (hor)" })

-- New terminal buffer in a vertical split
map("n", "<leader>tv", "<cmd>vert te<CR>", { desc = "New terminal (vert)" })

-- Back to normal mode in terminal
map("t", "<C-Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Close a terminal
map({ "n", "t" }, "<C-S-Esc>", [[<C-\><C-n><cmd>bd!<cr>]], {
  desc = "Close terminal",
})

-- Toggle an existing terminal
map("n", "<leader>tt", function()
  local terminals = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_buf_is_loaded(buf)
      and vim.bo[buf].buftype == "terminal"
    then
      local name = vim.api.nvim_buf_get_name(buf)
      -- local short_name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
      local label = name ~= "" and vim.fn.fnamemodify(name, ":t") or ("terminal-" .. buf)

      table.insert(terminals, {
        bufnr = buf,
        label = string.format("[%d] %s", buf, label),
      })
    end
  end

  if #terminals == 0 then
    vim.notify("No terminal buffers found", vim.log.levels.INFO)
    return
  end

  vim.ui.select(terminals, {
    prompt = "Select a terminal buffer for this window:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then return end

    vim.api.nvim_set_current_buf(choice.bufnr)
    vim.cmd("startinsert")
  end)
end, {
  desc = "Toggle a terminal",
})

-- Rename current terminal buffer
map("n", "<leader>tr", function()
  local bufnr = vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].buftype ~= "terminal" then
    vim.notify("This can only be used in a terminal buffer", vim.log.levels.WARN)
    return
  end

  vim.ui.input({
    prompt = "New term buffer name: ",
  }, function(input)
    if not input or input == "" then return end

    pcall(vim.api.nvim_buf_set_name, bufnr, "term://" .. input)
    vim.notify("Terminal buffer renamed to " .. input, vim.log.levels.INFO)
  end)
end, { desc = "Rename this terminal" })

-- Restart Neovim
map(
  "n",
  "<leader>or",
  "<cmd>restart<CR>",
  { noremap = true, silent = true, desc = "Restart Neovim" }
)

-- Create new tab
map("n", "<leader>bT", "<cmd>tabnew<CR>", { desc = "New tab" })

-- Yank the entire buffer
local function yank_entire_buffer()
  vim.cmd("%y+")
  local lines = vim.api.nvim_buf_line_count(0)
  vim.notify(("Yanked %d lines"):format(lines))
end

map("n", "<leader>oy", yank_entire_buffer, {
  desc = "Yank entire buffer",
})

-- Save buffer(s)
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save the buffer" })
map("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all buffers" })

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
