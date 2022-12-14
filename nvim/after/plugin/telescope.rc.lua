local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      media_files = {
        -- filetypes whitelist
        -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
        filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "pdf" },
        find_cmd = "rg" -- find command (defaults to `fd`)
      },
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["N"] = fb_actions.create,
          ["h"] = fb_actions.goto_parent_dir,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
  },
}

telescope.load_extension("file_browser")

vim.keymap.set('n', '<Leader>r', function()
  builtin.live_grep()
end, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<Leader>t', function()
  builtin.help_tags()
end, { desc = '[S]earch [H]elp' })

vim.keymap.set('n', '\\\\', function()
  builtin.resume()
end, { desc = '[ ] Resume buffers' })
vim.keymap.set('n', '<Leader><Leader>', function()
  builtin.buffers()
end, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<Leader>dl', function()
  builtin.diagnostics()
end, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<C-p>',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<Leader>?', function()
  builtin.oldfiles()
end, { desc = '[?] Find recently opened files' })
vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end, { desc = '[S]earch files from current path' })
