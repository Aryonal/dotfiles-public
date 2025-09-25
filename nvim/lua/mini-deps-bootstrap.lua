-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/nvim-mini/mini.nvim",
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup()

-- local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local add = MiniDeps.add

local function _packadd(spec)
    add(spec, { bang = true })
end

_packadd("tpope/vim-surround")
_packadd("tpope/vim-repeat")
_packadd("tpope/vim-fugitive")
_packadd("tpope/vim-rhubarb")

_packadd({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    monitor = "main",
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
})
_packadd({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })
_packadd({ source = "aaronik/treewalker.nvim" })
_packadd({ source = "neovim/nvim-lspconfig" })
_packadd({ source = "stevearc/conform.nvim" })
_packadd({ source = "mfussenegger/nvim-lint" })
_packadd({ source = "lewis6991/gitsigns.nvim" })
_packadd({ source = "stevearc/aerial.nvim" })
_packadd({ source = "projekt0n/github-nvim-theme" })

_packadd({
    source = "nvim-neo-tree/neo-tree.nvim",
    depends = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    }
})

_packadd({ source = "nmac427/guess-indent.nvim" })
_packadd({ source = "folke/snacks.nvim" })
_packadd({ source = "folke/flash.nvim" })
_packadd({ source = "RRethy/vim-illuminate" })
_packadd({ source = "kosayoda/nvim-lightbulb" })
_packadd({ source = "dstein64/nvim-scrollview" })
_packadd({ source = "folke/which-key.nvim" })
_packadd({ source = "rgroli/other.nvim" })
_packadd({ source = "retran/meow.yarn.nvim" })

-- lazy plugins?
_packadd({ source = "folke/lazydev.nvim" })

-- later(function() vim.cmd([[ packadd my-debug-plugin]]) end)
-- if vim.g.debug then now(function() vim.cmd([[ packadd my-debug-plugin]]) end) end
if vim.g.debug then vim.cmd([[packadd! my-debug-plugin]]) end
