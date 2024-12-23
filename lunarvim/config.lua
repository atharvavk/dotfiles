-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.wo.relativenumber = true
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

lvim.plugins = {
  --utility plugins
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  {
    "atiladefreitas/lazyclip",
    config = function()
        require("lazyclip").setup()
    end,
    keys = {
        { "<leader>y", ":lua require('lazyclip').show_clipboard()<CR>", desc = "Open Clipboard Manager" },
    },
  },
  --java plugins
  "mfussenegger/nvim-jdtls",
  --
  -- rust plugins
  --
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  --go plugins
  "olexsmir/gopher.nvim",
  "leoluz/nvim-dap-go",
}

--keybindings
vim.keymap.set("i", "jk", "<Esc>", {silent = true, noremap = true, desc = "Go to normal mode from insert mode"})
vim.keymap.set("i", "kj", "<Esc>", {silent = true, noremap = true, desc = "Go to normal mode from insert mode"})


--
--other settings
--
--use same clipboard as system keyboard
vim.o.clipboard = "unnamedplus"
