-- Reduce startup time with this experimental Lua module loader
vim.loader.enable()

-- Define a global config table for passing data across modules
-- It can be used as `_G.config` and `Config`
_G.Config = {}

-- a wrapper for vim.api.nvim_create_autocmd with the augroup set to "peylix-config"
Config.augr = vim.api.nvim_create_augroup("peylix-config", {})

-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  vim.api.nvim_create_autocmd(
    "PackChanged",
    { group = Config.augr, pattern = "*", callback = f, desc = desc }
  )
end

-- Enable ui2
require("vim._core.ui2").enable({ enable = true })

-- Load configs
require("config.options")
require("config.keymaps")
require("config.misc")
require("config.colorschemes")
require("plugins")
