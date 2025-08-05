return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            -- "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
            "HakonHarnes/img-clip.nvim",
            -- {
            --     -- Make sure to set this up properly if you have lazy=true
            --     "MeanderingProgrammer/render-markdown.nvim",
            --     opts = {
            --         file_types = { "markdown", "Avante" },
            --     },
            --     ft = { "markdown", "Avante" },
            -- },
        },
        opts = {
            -- add any opts here
            -- for example
            provider = "claude",
            providers = {
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-sonnet-4-20250514",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480,
                    },
                },
                openai = {
                    endpoint = "https://api.openai.com/v1",
                    model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
                    timeout = 30000,  -- Timeout in milliseconds, increase this for reasoning models
                }
            },
            highlights = {
                ---@type AvanteConflictHighlights
                diff = {
                    current = "DiffText",
                    incoming = "DiffAdd",
                },
            },
            windows = {
                ask = {
                    floating = false,
                }
            },
            input = {
                provider = "native", -- "native" | "dressing" | "snacks"
            },
            selector = {
                provider = "fzf_lua",
                provider_opts = {},
            },
        },
        config = function(_, opts)
            -- show vertical border for sidebar
            vim.cmd([[
                hi! link AvanteSidebarWinSeparator FloatBorder
            ]])

            require("avante").setup(opts)
            -- if you want to use the default keymaps, uncomment the line below
            -- require("avante").load_default_keymaps()
        end,
    }
}
