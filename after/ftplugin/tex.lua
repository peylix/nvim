local wo = vim.wo[0][0] -- current window, current buffer
local bo = vim.bo
local map = vim.keymap.set

wo.wrap = true
wo.linebreak = true
wo.breakindent = true
wo.showbreak = "↳ "

-- set spell checking
wo.spell = true
bo.spelllang = "en_us,cjk"

-- Only for the current buffer
local opts_expr = { expr = true, silent = true, buffer = true }
local opts_local = { silent = true, buffer = true }

-- if there is no count prefix, move by display lines, otherwise move by actual lines
map("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, opts_expr)
map("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, opts_expr)
map("x", "j", "gj", opts_local)
map("x", "k", "gk", opts_local)

-- move to beginning and end of display lines
-- map('n', '0', 'g0', opts_local)
-- map('n', '$', 'g$', opts_local)
-- map({'x','o'}, '0', 'g0', opts_local)
-- map({'x','o'}, '$', 'g$', opts_local)
