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
                normal_hl = "TabLine",
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

function M.winnr(win_id)
    return string.format("%d", vim.api.nvim_win_get_number(win_id or 0))
end

---PERF: use cache
function M.filepath(noname)
    local path = vim.fn.expand("%:p")
    if path == "" then
        return noname
    else
        -- "%" seems not to be so reliable
        local cwd = vim.fn.getcwd() .. "/"
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
function M.gitsigns_b_branch(trunc_len, omit)
    if trunc_len == nil then
        trunc_len = 20
    end
    if vim.b.gitsigns_status_dict then
        local branch = vim.b.gitsigns_status_dict.head
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
        return string.format("%s %s", M.cfg.icons.git_branch, branch)
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
            if enable_hl then
                diff = diff .. string.format("%%#%s#", normal_hl .. "Added")
            end
            diff = diff .. string.format("+%d", added)
        end
        if changed ~= nil and changed > 0 then
            if enable_hl then
                diff = diff .. string.format("%%#%s#", normal_hl .. "Changed")
            end
            diff = diff .. string.format("~%d", changed)
        end
        if removed ~= nil and removed > 0 then
            if enable_hl then
                diff = diff .. string.format("%%#%s#", normal_hl .. "Removed")
            end
            diff = diff .. string.format("-%d", removed)
        end

        return string.format("%s%%#%s#", diff, normal_hl or "StatusLine")
    end
    return ""
end

function M.diagnostics(bufnr, normal_hl)
    local res = {}
    for _, d in ipairs(vim.diagnostic.get(bufnr)) do
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
    return table.concat(components, " ") .. string.format("%%#%s#", normal_hl or "Normal")
end

function M.indentation()
    local spacetab = " Tab "
    local indents = vim.bo.tabstop
    if vim.bo.expandtab then
        spacetab = " "
        indents = vim.bo.softtabstop
        if indents < 0 then
            indents = vim.bo.shiftwidth
        end
    end
    local shifts = vim.bo.shiftwidth

    return spacetab .. indents .. ":" .. shifts
end

-- Function to get file encoding
function M.file_encoding()
    local fc = vim.bo.fileencoding
    if fc == "utf-8" or fc == "" then
        return ""
    end
    return string.format("[%s]", vim.bo.fileencoding)
end

function M.file_format()
    local ff = vim.bo.fileformat
    if ff == "unix" or ff == "" then
        return ""
    end
    return format_map[vim.bo.fileformat]
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
