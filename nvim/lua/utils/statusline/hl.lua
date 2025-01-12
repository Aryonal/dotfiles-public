local M = {
    cfg = {
        hl = {
            enabled = true,
            statusline = {
                enabled = true,
                normal_hl = "StatusLine",
                bold = true,
                diag = false,
                diff = false,
            },
            tabline = {
                enabled = true,
                normal_hl = "TabLineFill",
                bold = true,
                diag = true,
            },
        },
    },
}

local function get_source_hl(hl)
    local h = vim.api.nvim_get_hl(0, { name = hl, link = true })
    while h.link do
        h = vim.api.nvim_get_hl(0, { name = h.link, link = true })
    end

    return h
end

function M.setup(cfg)
    if cfg == nil then
        cfg = {}
    end
    M.cfg = vim.tbl_deep_extend("force", {}, M.cfg, cfg)

    if not M.cfg.hl.enabled then return end

    M._build()

    local augroup = vim.api.nvim_create_augroup("utils/statusline/hl.lua", {})
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        pattern = "*",
        callback = function()
            M._build()
        end,
    })
end

function M._build()
    -- builtin hl --
    local DiagHint = get_source_hl("DiagnosticHint")
    local DiagInfo = get_source_hl("DiagnosticInfo")
    local DiagWarn = get_source_hl("DiagnosticWarn")
    local DiagError = get_source_hl("DiagnosticError")
    local Added = get_source_hl("Added")
    local Changed = get_source_hl("Changed")
    local Removed = get_source_hl("Removed")

    if M.cfg.hl.statusline.enabled then
        local hl = M.cfg.hl.statusline.normal_hl
        local StatusLine = get_source_hl(hl)
        -- bold text --
        local StatusLineBold = vim.tbl_deep_extend("force", {}, StatusLine, {
            bold = true,
        })
        if M.cfg.hl.statusline.bold then vim.api.nvim_set_hl(0, hl .. "Bold", StatusLineBold) end
        -- diag text --
        -- hint
        local StatusLineHint = vim.tbl_deep_extend("force", {}, DiagHint, {
            bg = StatusLine.bg,
        })
        if M.cfg.hl.statusline.diag then vim.api.nvim_set_hl(0, hl .. "Hint", StatusLineHint) end
        -- info
        local StatusLineInfo = vim.tbl_deep_extend("force", {}, DiagInfo, {
            bg = StatusLine.bg,
        })
        if M.cfg.hl.statusline.diag then vim.api.nvim_set_hl(0, hl .. "Info", StatusLineInfo) end
        -- warn
        local StatusLineWarn = vim.tbl_deep_extend("force", {}, DiagWarn, {
            bg = StatusLine.bg,
        })
        if M.cfg.hl.statusline.diag then vim.api.nvim_set_hl(0, hl .. "Warn", StatusLineWarn) end
        -- error
        local StatusLineError = vim.tbl_deep_extend("force", {}, DiagError, {
            bg = StatusLine.bg,
        })
        if M.cfg.hl.statusline.diag then vim.api.nvim_set_hl(0, hl .. "Error", StatusLineError) end
        -- diff --
        -- added
        local StatusLineAdded = vim.tbl_deep_extend("force", {}, Added, {
            bg = StatusLine.bg,
        })
        if M.cfg.hl.statusline.diff then vim.api.nvim_set_hl(0, hl .. "Added", StatusLineAdded) end
        -- changed
        local StatusLineChanged = vim.tbl_deep_extend("force", {}, Changed, {
            bg = StatusLine.bg,
        })
        if M.cfg.hl.statusline.diff then vim.api.nvim_set_hl(0, hl .. "Changed", StatusLineChanged) end
        -- removed
        local StatusLineRemoved = vim.tbl_deep_extend("force", {}, Removed, {
            bg = StatusLine.bg,
        })
        if M.cfg.hl.statusline.diff then vim.api.nvim_set_hl(0, hl .. "Removed", StatusLineRemoved) end
    end


    if M.cfg.hl.tabline.enabled then
        local hl = M.cfg.hl.tabline.normal_hl
        local TabLineFill = get_source_hl(hl)

        -- bold text --
        local TabLineFillBold = vim.tbl_deep_extend("force", {}, TabLineFill, {
            bold = true,
        })
        if M.cfg.hl.statusline.bold then vim.api.nvim_set_hl(0, hl .. "Bold", TabLineFillBold) end
        -- diag --
        local TabLineFillHint = vim.tbl_deep_extend("force", {}, TabLineFill, {
            fg = DiagHint.fg,
        })
        if M.cfg.hl.tabline.diag then vim.api.nvim_set_hl(0, hl .. "Hint", TabLineFillHint) end
        local TabLineFillInfo = vim.tbl_deep_extend("force", {}, TabLineFill, {
            fg = DiagInfo.fg,
        })
        if M.cfg.hl.tabline.diag then vim.api.nvim_set_hl(0, hl .. "Info", TabLineFillInfo) end
        local TabLineFillWarn = vim.tbl_deep_extend("force", {}, TabLineFill, {
            fg = DiagWarn.fg,
        })
        if M.cfg.hl.tabline.diag then vim.api.nvim_set_hl(0, hl .. "Warn", TabLineFillWarn) end
        local TabLineFillError = vim.tbl_deep_extend("force", {}, TabLineFill, {
            fg = DiagError.fg,
        })
        if M.cfg.hl.tabline.diag then vim.api.nvim_set_hl(0, hl .. "Error", TabLineFillError) end
    end
end

return M
