local keymaps = {
    yank = "<leader>gy",
    open_in_browser = "<leader>gb",
}
return {
    "ruifm/gitlinker.nvim",
    keys = {
        keymaps.open_in_browser,
        keymaps.yank,
    },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
        require("gitlinker").setup({
            -- opts = {
            --   remote = nil, -- force the use of a specific remote
            --   -- adds current line nr in the url for normal mode
            --   add_current_line_on_normal_mode = true,
            --   -- callback for what to do with the url
            --   -- action_callback = require"gitlinker.actions".open_in_browser,
            --   action_callback = require"gitlinker.actions".copy_to_clipboard,
            --   -- print the url after performing the action
            --   print_url = true,
            -- },
            callbacks = {
                ["github.com"] = require("gitlinker.hosts").get_github_type_url,
                -- ["gitlab.com"] = require"gitlinker.hosts".get_gitlab_type_url,
                -- ["try.gitea.io"] = require"gitlinker.hosts"get_gitea_type_url,
                -- ["codeberg.org"] = require"gitlinker.hosts"get_gitea_type_url,
                -- ["bitbucket.org"] = require"gitlinker.hosts"get_bitbucket_type_url,
                -- ["try.gogs.io"] = require"gitlinker.hosts"get_gogs_type_url,
                -- ["git.sr.ht"] = require"gitlinker.hosts"get_srht_type_url,
                -- ["git.launchpad.net"] = require"gitlinker.hosts"get_launchpad_type_url,
                -- ["repo.or.cz"] = require"gitlinker.hosts"get_repoorcz_type_url,
                -- ["git.kernel.org"] = require"gitlinker.hosts"get_cgit_type_url,
                -- ["git.savannah.gnu.org"] = require"gitlinker.hosts"get_cgit_type_url
            },
            -- default mapping to call url generation with action_callback
            mappings = keymaps.yank,
        })

        -- additional keymaps to open selected in browser
        local map = require("utils.vim").set_keymap
        map({
            keymaps.open_in_browser,
            '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
            desc = "[GitLinker] Goto Browser",
        })
        map({
            keymaps.open_in_browser,
            [[<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>]],
            mode = "v",
            desc = "[GitLinker] Goto Browser",
        })
    end,
}
