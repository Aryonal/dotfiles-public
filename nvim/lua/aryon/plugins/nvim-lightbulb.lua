return {
    "kosayoda/nvim-lightbulb",
    config = function()
        require("nvim-lightbulb").setup({
            autocmd = {
                enabled = true,
            },
            sign = {
                enabled = false,
            },
            virtual_text = {
                enabled = true,
                text = require("share.icons").code_action_virt_text,
                pos = "eol",
                hl = "LightBulbVirtualText",
                hl_mode = "combine",
            },
        })
    end
}
