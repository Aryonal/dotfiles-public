local _setup_once = require("helper.lua").once(function()
    -- packadd fidget.nvim
    if MiniDeps then
        MiniDeps.add({ source = "j-hui/fidget.nvim" })
    end

    local ok, fidget = pcall(require, "fidget")
    if not ok then
        return
    end

    fidget.setup {
        progress = {
            display = {
                done_icon = "✓",
            }
        }
    }
end)

require("helper.lazy").once_on_events(
    "after/plugin/fidget.lua",
    { "BufReadPre", "BufWritePre", "BufNewFile" },
    _setup_once
)
