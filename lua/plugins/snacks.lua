-- snacks.nvim
vim.pack.add({ "https://github.com/folke/snacks.nvim" })

local snacks = require("snacks")

local map = vim.keymap.set

snacks.setup({
  picker = {
    enabled = true,
    layout = {
      preset = "ivy",
      layout = {
        backdrop = 60,
      },
    },
    win = {
      input = {
        keys = {
          ["<a-c>"] = {
            "toggle_cwd",
            mode = { "n", "i" },
          },
        },
      },
    },
    sources = {
      gh_issue = {},
      gh_pr = {},
    },
  },
  gh = {
    enabled = true,
  },
  image = {
    enabled = true,
  },
  scratch = {
    enabled = true,
  },
  indent = {
    enabled = true,
    animate = {
      enabled = false,
    },
    chunk = {
      enabled = false,
    },
  },
  -- TODO: properly managing the terminal buffers
  terminal = {
    enabled = true,
    bo = {
      filetype = "snacks_terminal",
    },
    wo = {},
    stack = true, -- when enabled, multiple split windows with the same position will be stacked together (useful for terminals)
    keys = {
      q = "hide",
      gf = function(self)
        local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
        if f == "" then
          Snacks.notify.warn("No file under cursor")
        else
          self:hide()
          vim.schedule(function()
            vim.cmd("e " .. f)
          end)
        end
      end,
      term_normal = {
        "<esc>",
        function(self)
          self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
          if self.esc_timer:is_active() then
            self.esc_timer:stop()
            vim.cmd("stopinsert")
          else
            self.esc_timer:start(200, 0, function() end)
            return "<esc>"
          end
        end,
        mode = "t",
        expr = true,
        desc = "Double escape to normal mode",
      },
    },
  },
})

-- Resume previous search
map("n", "<leader>f<CR>", function()
  Snacks.picker.resume()
end, { desc = "Resume previous search" })

-- Marks
map("n", "<leader>f'", function()
  Snacks.picker.marks()
end, { desc = "Marks" })

-- Search config files
map("n", "<leader>fa", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find config files" })

-- Buffers
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

-- Word at cursor
map("n", "<leader>fc", function()
  Snacks.picker.grep_word()
end, { desc = "Word at cursor" })

-- Commands
map("n", "<leader>fC", function()
  Snacks.picker.commands()
end, { desc = "Commands" })

-- Find files
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find files" })

-- Find files (include hidden)
map("n", "<leader>fF", function()
  Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find files (include hidden)" })

-- Git tracked files
map("n", "<leader>fg", function()
  Snacks.picker.git_files()
end, { desc = "Git tracked files" })

-- Help Tags
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help Tags" })

-- Keymaps
map("n", "<leader>fk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })

-- Lines (current buffer)
map("n", "<leader>fl", function()
  Snacks.picker.lines()
end, { desc = "Lines" })

-- Man Pages
map("n", "<leader>fm", function()
  Snacks.picker.man()
end, { desc = "Man Pages" })

-- Notifications
map("n", "<leader>fn", function()
  Snacks.picker.notifications()
end, { desc = "Notifications" })

-- Old Files (recent files)
map("n", "<leader>fo", function()
  Snacks.picker.recent()
end, { desc = "Old Files" })

-- Old Files (current directory only)
map("n", "<leader>f0", function()
  Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Old Files (current directory)" })

-- Projects
map("n", "<leader>fp", function()
  Snacks.picker.projects()
end, { desc = "Projects" })

-- Registers
map("n", "<leader>fr", function()
  Snacks.picker.registers()
end, { desc = "Registers" })

-- Smart (buffers, recent, files)
map("n", "<leader>fs", function()
  Snacks.picker.smart()
end, { desc = "Smart (buffers, recent, files)" })

-- Colorschemes
map("n", "<leader>ft", function()
  Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })

-- Undo History
map("n", "<leader>fu", function()
  Snacks.picker.undo()
end, { desc = "Undo History" })

-- Live Grep
map("n", "<leader>fw", function()
  Snacks.picker.grep()
end, { desc = "Live Grep" })

-- Live Grep (include hidden files)
map("n", "<leader>fW", function()
  Snacks.picker.grep({ hidden = true, ignored = true })
end, { desc = "Live Grep (include hidden)" })

-- Git Branches
map("n", "<leader>gb", function()
  Snacks.picker.git_branches()
end, { desc = "Git Branches" })

-- Git Commits (repository)
map("n", "<leader>gc", function()
  Snacks.picker.git_log()
end, { desc = "Git Commits (repository)" })

-- Git Commits (current file)
map("n", "<leader>gC", function()
  Snacks.picker.git_log_file()
end, { desc = "Git Commits (current file)" })

-- Git browse (open in browser)
map("n", "<leader>go", function()
  Snacks.gitbrowse()
end, { desc = "Git browse (open)" })

-- Git Status
map("n", "<leader>gt", function()
  Snacks.picker.git_status()
end, { desc = "Git Status" })

-- Git Stash
map("n", "<leader>gT", function()
  Snacks.picker.git_stash()
end, { desc = "Git Stash" })

-- LSP Symbols (document)
map("n", "<leader>ls", function()
  Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })

-- LSP Workspace Symbols
map("n", "<leader>lG", function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })

map("n", "<leader>gi", function()
  Snacks.picker.gh_issue()
end, { desc = "GitHub Issues (open)" })

map("n", "<leader>gI", function()
  Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub Issues (all)" })

map("n", "<leader>gq", function()
  Snacks.picker.gh_pr()
end, { desc = "GitHub Pull Requests (open)" })

map("n", "<leader>gQ", function()
  Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub Pull Requests (all)" })

map("n", "<leader>bt", function()
  Snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })

map("n", "<leader>bT", function()
  Snacks.scratch.select()
end, { desc = "Select Scratch Buffer" })

map("n", "<leader>bS", function()
  Snacks.scratch.select()
end, { desc = "Select Scratch Buffer" })

map("n", "<leader>tn", function()
  Snacks.terminal.open()
end, { desc = "New terminal" })

map("n", "<leader>tt", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })

map("n", "<leader>tl", function()
  Snacks.terminal.list()
end, { desc = "List terminal" })
