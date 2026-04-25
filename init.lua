-- Define a global config table for passing data across modules
-- It can be used as `_G.config` and `Config`
_G.Config = {}

-- a wrapper for vim.api.nvim_create_autocmd with the augroup set to "peylix-config"
local gr = vim.api.nvim_create_augroup("peylix-config", {})
Config.create_autocmd = function(event, opts)
  opts.group = gr
  vim.api.nvim_create_autocmd(event, opts)
end

-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.create_autocmd("PackChanged", { pattern = "*", callback = f, desc = desc })
end

-- Enable ui2
require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = "cmd",
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5, -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
})

require("config.colorschemes")
require("config.options")
require("config.keymaps")
require("config.misc")
require("plugins")
