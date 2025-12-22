-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.builtin.dap.active = true
lvim.builtin.dap.ui = {
  enable = false,
}

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
    lazy = false,   -- This plugin is already lazy
  },
  --go plugins
  "olexsmir/gopher.nvim",
  "leoluz/nvim-dap-go",

  -- hurl
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Optional, for markdown rendering with render-markdown.nvim
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown" },
        },
        ft = { "markdown" },
      },
    },
    ft = "hurl",
    opts = {
      -- Show debugging info
      debug = false,
      -- Show notification on run
      show_notification = false,
      -- Show response in popup or split
      mode = "split",
      -- Default formatter
      formatters = {
        json = { 'jq' }, -- Make sure you have install jq in your system, e.g: brew install jq
        html = {
          'prettier',    -- Make sure you have install prettier in your system, e.g: npm install -g prettier
          '--parser',
          'html',
        },
        xml = {
          'tidy', -- Make sure you have installed tidy in your system, e.g: brew install tidy-html5
          '-xml',
          '-i',
          '-q',
        },
      },
      -- Default mappings for the response popup or split views
      mappings = {
        close = 'q',          -- Close the response popup or split view
        next_panel = '<C-n>', -- Move to the next response popup window
        prev_panel = '<C-p>', -- Move to the previous response popup window
      },
    },
    keys = {
      -- Run API request
      { "<leader>A",  "<cmd>HurlRunner<CR>",        desc = "Run All requests" },
      { "<leader>a",  "<cmd>HurlRunnerAt<CR>",      desc = "Run Api request" },
      { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
      { "<leader>tE", "<cmd>HurlRunnerToEnd<CR>",   desc = "Run Api request from current entry to end" },
      { "<leader>tm", "<cmd>HurlToggleMode<CR>",    desc = "Hurl Toggle Mode" },
      { "<leader>tv", "<cmd>HurlVerbose<CR>",       desc = "Run Api in verbose mode" },
      { "<leader>tV", "<cmd>HurlVeryVerbose<CR>",   desc = "Run Api in very verbose mode" },
      -- Run Hurl request in visual mode
      { "<leader>h",  ":HurlRunner<CR>",            desc = "Hurl Runner",                              mode = "v" },
    },
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
  },
  --opencode extension
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
        { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
        { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })

      vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
        { expr = true, desc = "Add range to opencode" })
      vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
        { expr = true, desc = "Add line to opencode" })

      vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
        { desc = "opencode half page up" })
      vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
        { desc = "opencode half page down" })

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
  },
  -- Avante integration
  {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- this file can contain specific instructions for your project
      instructions_file = "avante.md",
      -- for example
      provider = "ollama",
      providers = {
        ollama = {
          endpoint = "https://ollama.com",
          model = "qwen2.5-coder:32b", -- pick any cloud-supported model
          timeout = 30000,

          -- Avante treats Ollama as OpenAI-compatible
          api_key = os.getenv("OLLAMA_API_KEY"),
          api_key_name = "OLLAMA_API_KEY",
          parse_api_key = function()
            return vim.env.OLLAMA_API_KEY
          end,
          is_env_set = require("avante.providers.ollama").check_endpoint_alive,
          extra_request_body = {
            temperature = 0.6,
            max_tokens = 16384,
          },
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        moonshot = {
          endpoint = "https://api.moonshot.ai/v1",
          model = "kimi-k2-0711-preview",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-mini/mini.pick",           -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua",              -- for file_selector provider fzf
      "stevearc/dressing.nvim",        -- for input provider dressing
      "folke/snacks.nvim",             -- for input provider snacks
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}


--keybindings
vim.keymap.set("i", "jk", "<Esc>", { silent = true, noremap = true, desc = "Go to normal mode from insert mode" })
vim.keymap.set("i", "kj", "<Esc>", { silent = true, noremap = true, desc = "Go to normal mode from insert mode" })


--
--other settings
--
--use same clipboard as system keyboard
vim.o.clipboard = "unnamedplus"

local lspconfig = require("lspconfig")

lspconfig.terraformls.setup({
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "tf", "terraform-vars" },
  root_dir = lspconfig.util.root_pattern(".terraform", ".git"),
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.tf",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})



-- =========================
-- DAP (Minimal + Floating UI)
-- =========================

local dap = require("dap")
local dapui = require("dapui")

-- -------------------------
-- dap-ui setup (DEFINE layouts only)
-- -------------------------
dapui.setup({
  layouts = {
    -- Bottom panel: console + repl
    {
      position = "bottom",
      size = 12,
      elements = { "console", "repl" },
    },
    -- Right panel: call stack only
    {
      position = "right",
      size = 35,
      elements = { "stacks" },
    },
  },
  controls = { enabled = false },
})

-- -------------------------
-- Remove LunarVim default dap-ui listeners
-- -------------------------
dap.listeners.after.event_initialized["lvim-dap-ui"] = nil
dap.listeners.before.event_terminated["lvim-dap-ui"] = nil
dap.listeners.before.event_exited["lvim-dap-ui"] = nil

dap.listeners.after.event_initialized["dapui_config"] = nil
dap.listeners.before.event_terminated["dapui_config"] = nil
dap.listeners.before.event_exited["dapui_config"] = nil

-- Minimal UI lifecycle
dap.listeners.after.event_initialized["minimal-ui"] = function()
  require("nvim-dap-virtual-text").enable()
end

dap.listeners.before.event_terminated["minimal-ui"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["minimal-ui"] = function()
  dapui.close()
end

-- -------------------------
-- Clear inline virtual text on exit
-- -------------------------
dap.listeners.before.event_terminated["virtual-text-cleanup"] = function()
  require("nvim-dap-virtual-text").disable()
end

dap.listeners.before.event_exited["virtual-text-cleanup"] = function()
  require("nvim-dap-virtual-text").disable()
end

-- -------------------------
-- Keymaps (LunarVim-safe)
-- -------------------------

-- DAP: Evaluate variable / expression under cursor (floating)
lvim.keys.normal_mode["<leader>de"] = function()
  dapui.eval(nil, {
    enter = true,
    width = 60,
    height = 15,
  })
end

-- DAP: Multiline expression evaluation (floating editor)
lvim.keys.normal_mode["<leader>dE"] = function()
  require("dapui").eval(vim.fn.input("Eval > "), {
    enter = true,
    width = 70,
    height = 20,
  })
end

-- DAP: Show local variables (floating scopes)
lvim.keys.normal_mode["<leader>dl"] = function()
  dapui.float_element("scopes", {
    enter = true,
    width = 70,
    height = 25,
  })
end

-- DAP: toggle REPL and console
lvim.keys.normal_mode["<leader>d;"] = function()
  require("dapui").toggle({ layout = 2 })
end

-- DAP: Show / manage watch expressions (floating)
lvim.keys.normal_mode["<leader>dw"] = function()
  dapui.float_element("watches", {
    width = 70,
    height = 20,
  })
end

-- -------------------------
-- Inline variable hints
-- -------------------------
require("nvim-dap-virtual-text").setup({
  virt_text_pos = "eol",
  commented = true,
  only_first_definition = true,
})
