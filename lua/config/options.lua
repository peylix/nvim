local o = vim.o
local wo = vim.wo
local g = vim.g
local opt = vim.opt

-- General
g.mapleader = " "
g.maplocalleader = ","

o.mouse = "a"
-- o.mousescroll = 'ver:25,hor:6' -- customize mouse scroll
o.switchbuf = "usetab" -- use already opened buffers when switching
o.undofile = true -- for persistent undo

o.shada = "'100,<50,s10,:1000,/100,@100,h"

-- UI
o.breakindent = true -- indent wrapped lines to match line start
o.breakindentopt = "list:-1" -- add padding for lists if "wrap" is set
o.colorcolumn = "+1" -- draw column on the right of maximum width
o.cursorline = true -- enable current line highlighting
o.linebreak = true -- wrap lines at "breakat" if "warp" is set
o.number = true
wo.relativenumber = true
o.pumborder = "single" -- use border in popup menu
o.pumheight = 10 -- make popup menu smaller -- TODO: ?
o.pummaxwidth = 100 -- limit the maximum width of the popup menu
o.ruler = false
o.shortmess = "CFOSWaco" -- disable some completion messages
o.showmode = false
o.signcolumn = "yes" -- always show signcolumn
o.splitbelow = true -- horizontal splits should be placed below
o.splitkeep = "screen"
o.splitright = true -- reduce splits should be placed to the right
o.winborder = "single" -- use border in floating windows
o.wrap = false -- do not visually wrap lines -- TODO: ?

o.cursorlineopt = "screenline,number" -- show cursor line per screen line

o.list = true -- show whitespace characters

opt.listchars = {
  nbsp = "␣", -- show non-breaking spaces as ␣
  -- trail = '•', -- show trailing spaces as •
  extends = "⟩", -- when line content exceeds right boundary, show ⟩
  precedes = "⟨", -- when line content exceeds left boundary, show ⟨
}

-- Folds
o.foldlevel = 10
o.foldmethod = "indent"
o.foldnestmax = 10
o.foldtext = ""

-- Editing
o.autoindent = true
o.expandtab = true
o.formatoptions = "rqnl1j" -- improve comment editing
o.ignorecase = true -- ignore case during search
o.incsearch = true -- show search matches while typing
o.infercase = true -- infer case in built-in completion
o.shiftwidth = 4 -- use 4 spaces for indentation
o.smartcase = true -- respect case if search pattern has upper case
o.smartindent = true -- make indenting smart
o.spelloptions = "camel" -- treat parts in camelCase word as separate words
o.tabstop = 4
o.virtualedit = "block"

o.iskeyword = "@,48-57,_,192-255,-" -- treat dash as `word` textobject part

o.clipboard = "unnamedplus" -- use system clipboard

-- use xclip for clipboard on Linux
if vim.fn.has("linux") == 1 then vim.g.clipboard = "xclip" end
