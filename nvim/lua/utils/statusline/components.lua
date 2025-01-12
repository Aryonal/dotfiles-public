local wrap_hl = require("utils.statusline.utils").wrap_hl
local ctx_get_buf = require("utils.statusline.utils").ctx_get_buf

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
        icons = {
            git_branch = "",
            noname = "[無名]",
            hint = "H:",
            info = "I:",
            warn = "W:",
            err = "E:",
        },
    }
}

local path_util = require("utils/path")

local format_map = {
    ["dos"] = "CRLF",
    ["unix"] = "LF",
    ["mac"] = "CR",
}

function M.spaces(n)
    return string.rep(" ", n)
end

function M.winnr(ctx)
    return string.format("%d", vim.api.nvim_win_get_number(ctx.win_id or 0))
end

---PERF: use cache
function M.filepath(ctx, noname)
    local buf = ctx_get_buf(ctx)
    local path = vim.api.nvim_buf_get_name(buf)
    if path == "" then
        return noname
    else
        -- "%" seems not to be so reliable, return "%f%m%r" shows full path
        local cwd = vim.fn.getcwd(ctx.win_id or 0) .. "/"
        path = require("utils.lua").crop(path, cwd)

        return path
    end
end

--- Returns the current git status.
--- Example:
---  `"*"` or `""`
function M.git_g_status()
    if vim.g.statusline_git_status == nil or vim.g.statusline_git_status == 0 then
        return ""
    end

    return "*"
end

--- Returns the current git branch name.
--- Example:
---   ` master`
function M.gitsigns_g_branch(trunc_len)
    if trunc_len == nil then
        trunc_len = 20
    end
    if vim.g.gitsigns_head then
        local branch = vim.g.gitsigns_head
        if branch == nil then
            return ""
        end
        -- truncate branch name
        if string.len(branch) > trunc_len then
            branch = string.sub(branch, 0, trunc_len) .. "..."
        end
        return string.format("%s %s", M.cfg.icons.git_branch, branch)
    end
    return ""
end

--- Returns the current git branch name.
--- Example:
---   ` master`
function M.gitsigns_b_branch(ctx, trunc_len, omit)
    trunc_len = trunc_len or 20
    local status = vim.b.gitsigns_status_dict
    if status then
        local branch = status.head
        if branch == nil then
            return ""
        end
        if omit then
            if branch == vim.g.gitsigns_head then
                return ""
            end
        end
        -- truncate branch name
        if string.len(branch) > trunc_len then
            branch = string.sub(branch, 0, trunc_len) .. "..."
        end
        local s = string.format("%s %s", M.cfg.icons.git_branch, branch)
        return s
    end
    return ""
end

function M.gitsigns_diff(normal_hl)
    if vim.b.gitsigns_status_dict then
        local added = vim.b.gitsigns_status_dict.added
        local changed = vim.b.gitsigns_status_dict.changed
        local removed = vim.b.gitsigns_status_dict.removed

        local enable_hl = false
        if M.cfg.hl.enabled and normal_hl then
            if normal_hl == M.cfg.hl.statusline.normal_hl then
                enable_hl = M.cfg.hl.statusline.enabled and M.cfg.hl.statusline.diff
            elseif normal_hl == M.cfg.hl.tabline.normal_hl then
                enable_hl = M.cfg.hl.tabline.enabled and M.cfg.hl.tabline.diff
            end
        end

        local diff = ""
        if added ~= nil and added > 0 then
            local _added = string.format("+%d", added)
            if enable_hl then
                _added = wrap_hl(_added, normal_hl .. "Added")
            end
            diff = diff .. _added
        end
        if changed ~= nil and changed > 0 then
            local _changed = string.format("~%d", changed)
            if enable_hl then
                _changed = wrap_hl(_changed, normal_hl .. "Changed")
            end
            diff = diff .. _changed
        end
        if removed ~= nil and removed > 0 then
            local _removed = string.format("-%d", removed)
            if enable_hl then
                _removed = wrap_hl(_removed, normal_hl .. "Removed")
            end
            diff = diff .. _removed
        end

        return wrap_hl(diff, nil, normal_hl or "StatusLine")
    end
    return ""
end

function M.diagnostics(ctx, normal_hl)
    local res = {}
    for _, d in ipairs(vim.diagnostic.get(ctx and ctx.buf or nil)) do
        res[d.severity] = (res[d.severity] or 0) + 1
    end

    local components = {}

    local lv_hint = res[vim.diagnostic.severity["HINT"]]
    local lv_info = res[vim.diagnostic.severity["INFO"]]
    local lv_warn = res[vim.diagnostic.severity["WARN"]]
    local lv_err = res[vim.diagnostic.severity["ERROR"]]

    local enable_hl = false
    if M.cfg.hl.enabled and normal_hl then
        if normal_hl == M.cfg.hl.statusline.normal_hl then
            enable_hl = M.cfg.hl.statusline.enabled and M.cfg.hl.statusline.diag
        elseif normal_hl == M.cfg.hl.tabline.normal_hl then
            enable_hl = M.cfg.hl.tabline.enabled and M.cfg.hl.tabline.diag
        end
    end

    if lv_hint ~= nil and lv_hint > 0 then
        local s = ""
        if enable_hl then
            s = s .. "%#" .. normal_hl .. "Hint" .. "#"
        end
        s = s .. M.cfg.icons.hint .. lv_hint
        table.insert(components, s)
    end
    if lv_info ~= nil and lv_info > 0 then
        local s = ""
        if enable_hl then
            s = s .. "%#" .. normal_hl .. "Info" .. "#"
        end
        s = s .. M.cfg.icons.info .. lv_info
        table.insert(components, s)
    end
    if lv_warn ~= nil and lv_warn > 0 then
        local s = ""
        if enable_hl then
            s = s .. "%#" .. normal_hl .. "Warn" .. "#"
        end
        s = s .. M.cfg.icons.warn .. lv_warn
        table.insert(components, s)
    end
    if lv_err ~= nil and lv_err > 0 then
        local s = ""
        if enable_hl then
            s = s .. "%#" .. normal_hl .. "Error" .. "#"
        end
        s = s .. M.cfg.icons.err .. lv_err
        table.insert(components, s)
    end
    if #components == 0 then
        return ""
    end
    return wrap_hl(
        table.concat(components, " "),
        nil,
        normal_hl
    )
end

function M.indentation(ctx)
    local spacetab = " Tab "
    local indents = vim.bo.tabstop
    local expandtab = vim.bo.expandtab
    local softtabstop = vim.bo.softtabstop
    local shifts = vim.bo.shiftwidth
    if ctx.buf then
        local buf = ctx.buf
        indents = vim.api.nvim_get_option_value("tabstop", { buf = buf })
        expandtab = vim.api.nvim_get_option_value("expandtab", { buf = buf })
        softtabstop = vim.api.nvim_get_option_value("softtabstop", { buf = buf })
        shifts = vim.api.nvim_get_option_value("shiftwidth", { buf = buf })
    end

    if expandtab then
        spacetab = " "
        indents = softtabstop
        if indents < 0 then
            indents = shifts
        end
    end
    return spacetab .. indents .. ":" .. shifts
end

-- Function to get file encoding
function M.file_encoding(win_id)
    local fc = vim.bo.fileencoding
    if win_id then
        local buf = vim.api.nvim_win_get_buf(win_id)
        fc = vim.api.nvim_get_option_value("fileencoding", { buf = buf })
    end
    if fc == "utf-8" or fc == "" then
        return ""
    end
    return string.format("[%s]", fc)
end

function M.file_format(win_id)
    local ff = vim.bo.fileformat
    if win_id then
        local buf = vim.api.nvim_win_get_buf(win_id)
        ff = vim.api.nvim_get_option_value("fileformat", { buf = buf })
    end
    if ff == "unix" or ff == "" then
        return ""
    end
    return format_map[ff]
end

function M.buffer_flags(bufnr, winid)
    local flags = ""

    -- Modified flag
    if bufnr ~= nil and vim.bo[bufnr].modified then
        flags = flags .. "[+]"
    end

    -- Modifiable
    if bufnr ~= nil and not vim.bo[bufnr].modifiable then
        flags = flags .. "[-]"
    end

    -- Readonly flag
    if bufnr ~= nil and vim.bo[bufnr].readonly then
        flags = flags .. "[RO]"
    end

    -- Help buffer flag
    if bufnr ~= nil and vim.bo[bufnr].buftype == "help" then
        flags = flags .. "[Help]"
    end

    -- Preview flag
    if winid ~= nil and vim.wo[winid] ~= nil and vim.wo[winid].previewwindow then
        flags = flags .. "[Preview]"
    end

    return flags
end

function M.cwd()
    return path_util.get_cwd_short(32)
end

local function get_tab_label(n, is_current, noname_icon)
    local buflist = vim.fn.tabpagebuflist(n)
    local winnr = vim.fn.tabpagewinnr(n)
    local winid = vim.fn.win_getid(winnr, n)
    local bufnr = buflist[winnr]
    local file = vim.fn.bufname(bufnr)
    local filename = vim.fn.fnamemodify(file, ":t")
    local label = filename ~= "" and filename or noname_icon

    -- Add buffer flags
    if is_current then
        label = label .. M.buffer_flags(bufnr, winid)
    end

    return label
end

function M.tabs()
    local current_tab = vim.fn.tabpagenr()
    local total_tabs = vim.fn.tabpagenr("$")

    local s = ""

    -- Add the tabs
    for i = 1, total_tabs do
        local is_current = i == current_tab
        local label = ""
        if is_current then
            label = get_tab_label(i, true, M.cfg.icons.noname)
        else
            label = get_tab_label(i, false, M.cfg.icons.noname)
        end


        if is_current then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end
        s = s .. "%" .. i .. "T"
        s = s .. " " .. i .. ":" .. label .. " "
    end

    -- Fill the rest of the tabline
    s = s .. "%#TabLineFill#%T"

    if M.cfg.tabline.hide_if_only_one_tab and total_tabs == 1 then
        return "%#TabLineFill#"
    end

    return s
end

function M.setup(cfg)
    if cfg == nil then
        return M
    end
    M.cfg = vim.tbl_deep_extend("force", M.cfg, cfg)

    return M
end

return M
