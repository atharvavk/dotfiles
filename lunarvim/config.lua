-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.builtin.dap.active = true
lvim.builtin.dap.ui = {
    enable = false,
}

-- Set tab settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

if vim.g.neovide then
    -- High refresh rate for smooth experience
    vim.g.neovide_refresh_rate = 120    -- Set to your display's refresh rate (120 or 144)
    vim.g.neovide_refresh_rate_idle = 5 -- Lower when idle to save battery

    -- Fast but visible cursor animations
    vim.g.neovide_cursor_animation_length = 0.05 -- Very quick (default is 0.13)
    vim.g.neovide_cursor_trail_size = 0.3        -- Subtle trail (default is 0.8)
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = true

    -- Fast scroll animations
    vim.g.neovide_scroll_animation_length = 0.2 -- Quick scroll (default is 0.3)

    -- Fast position animation
    vim.g.neovide_position_animation_length = 0.1 -- Quick window movement

    -- Keep nice visual effects
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0

    -- Cursor effects (optional, choose one you like)
    vim.g.neovide_cursor_vfx_mode = "railgun" -- or "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe"
    vim.g.neovide_cursor_vfx_opacity = 200.0
    vim.g.neovide_cursor_vfx_particle_lifetime = 0.8
    vim.g.neovide_cursor_vfx_particle_density = 7.0
end

vim.wo.relativenumber = true
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "ruff" })

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
                    'prettier',  -- Make sure you have install prettier in your system, e.g: npm install -g prettier
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
            vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,
                { desc = "Toggle opencode" })

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
    "ChristianChiarulli/swenv.nvim",
    "stevearc/dressing.nvim",
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/neotest",
    "nvim-neotest/neotest-python",
    "nvim-neotest/nvim-nio",
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        opts = {
            terminal_cmd =
            "jq 'del(.cachedGrowthBookFeatures)' ~/.claude.json > temp.json && mv temp.json ~/.claude.json && claude", -- Point to local installation
        },
        config = true,
        keys = {
            { "<leader>a",  nil,                              desc = "AI/Claude Code" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
            { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
            { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
            {
                "<leader>as",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
            },
            -- Diff management
            { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
        },
    },
    -- Parquet file viewer
    {
        "kyytox/data-explorer.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("data-explorer").setup()
        end,
    },
    -- mermaid renderer
    {
        "selimacerbas/markdown-preview.nvim",
        dependencies = { "selimacerbas/live-server.nvim" },
        config = function()
            require("markdown_preview").setup({
                -- all optional; sane defaults shown
                instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
                port = 0,                   -- 0 = auto (8421 for takeover, OS-assigned for multi)
                open_browser = true,
                debounce_ms = 300,
            })
        end,
    },
    -- codex
    {
        'kkrampis/codex.nvim',
        lazy = true,
        cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
        keys = {
            {
                '<leader>oc', -- Change this to your preferred keybinding
                function() require('codex').toggle() end,
                desc = 'Toggle Codex popup or side-panel',
                mode = { 'n', 't' }
            },
        },
        opts = {
            keymaps     = {
                toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
                quit = '<C-q>', -- Keybind to close the Codex window (default: Ctrl + q)
            },               -- Disable internal default keymap (<leader>cc -> :CodexToggle)
            border      = 'rounded', -- Options: 'single', 'double', or 'rounded'
            width       = 0.3, -- Width of the floating window (0.0 to 1.0)
            height      = 0.8, -- Height of the floating window (0.0 to 1.0)
            model       = nil, -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
            autoinstall = true, -- Automatically install the Codex CLI if not found
            panel       = true, -- Open Codex in a side-panel (vertical split) instead of floating window
            use_buffer  = false, -- Capture Codex stdout into a normal buffer instead of a terminal buffer
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

require("nvim-dap-virtual-text").setup({
    virt_text_pos = "eol",
    commented = true,
    only_first_definition = true,
})


-- =========================
-- PYTHON setup
-- =========================

-- Treesitter
lvim.builtin.treesitter.ensure_installed = {
    "python",
}

-- -------------------------
-- Python LSP (Pyright)
-- -------------------------
require("lvim.lsp.manager").setup("pyright", {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
            },
        },
    },
})

-- -------------------------
-- Python DAP
-- -------------------------
lvim.builtin.dap.active = true

local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
pcall(function()
    require("dap-python").setup(
        mason_path .. "packages/debugpy/venv/bin/python"
    )
end)

-- -------------------------
-- Virtualenv switching
-- -------------------------
lvim.builtin.which_key.mappings["C"] = {
    name = "Python",
    c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}
