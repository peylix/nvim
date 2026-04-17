vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.showbreak = "↳ "

vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us", "cjk" }

-- vim.opt_local.conceallevel = 2
-- vim.opt_local.concealcursor = "nc"

-- Only for the current buffer
local opts_expr = { expr = true, silent = true, buffer = true }
local opts_local = { silent = true, buffer = true }

-- if there is no count prefix, move by display lines, otherwise move by actual lines
vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, opts_expr)
vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, opts_expr)

-- for visual mode
vim.keymap.set("x", "j", "gj", opts_local)
vim.keymap.set("x", "k", "gk", opts_local)

-- move to beginning and end of display lines
-- vim.keymap.set('n', '0', 'g0', opts_local)
-- vim.keymap.set('n', '$', 'g$', opts_local)
-- vim.keymap.set({'x','o'}, '0', 'g0', opts_local)
-- vim.keymap.set({'x','o'}, '$', 'g$', opts_local)
