local M = {}

local path_util = require("utils/path")

local git_branch_icon = ""

local format_map = {
    ["dos"] = "CRLF",
    ["unix"] = "LF",
    ["mac"] = "CR",
}

function M.spaces(n)
    return string.rep(" ", n)
end

function M.winnr()
    return string.format("%d", vim.api.nvim_win_get_number(0))
end

---PERF: use cache
function M.filepath(noname_icon)
    if noname_icon == nil then
        noname_icon = "[無名]"
    end
    local path = vim.fn.expand("%:p")
    if path == "" then
        return noname_icon
    else
        -- "%" seems not to be so reliable
        local cwd = vim.fn.getcwd() .. "/"
        path = require("utils.lua").crop(path, cwd)
        return path
    end
end

function M.gitsigns_branch(icon, trunc_len)
    if icon == nil then
        icon = git_branch_icon
    end
    if trunc_len == nil then
        trunc_len = 20
    end
    if vim.b.gitsigns_status_dict then
        local branch = vim.b.gitsigns_status_dict.head
        -- truncate branch name
        if string.len(branch) > trunc_len then
            branch = string.sub(branch, 0, trunc_len) .. "..."
        end
        return string.format("%s %s", icon, branch)
    end
    return ""
end

function M.gitsigns_diff()
    if vim.b.gitsigns_status_dict then
        local added = vim.b.gitsigns_status_dict.added
        local changed = vim.b.gitsigns_status_dict.changed
        local removed = vim.b.gitsigns_status_dict.removed

        local diff = ""
        if added ~= nil and added > 0 then
            diff = diff .. string.format("+%d", added)
        end
        if changed ~= nil and changed > 0 then
            diff = diff .. string.format("~%d", changed)
        end
        if removed ~= nil and removed > 0 then
            diff = diff .. string.format("-%d", removed)
        end

        return string.format("%s", diff)
    end
    return ""
end

function M.diagnostics(bufnr, hint_icon, info_icon, warn_icon, err_icon)
    if hint_icon == nil then
        hint_icon = "H:"
    end
    if info_icon == nil then
        info_icon = "I:"
    end
    if warn_icon == nil then
        warn_icon = "W:"
    end
    if err_icon == nil then
        err_icon = "E:"
    end

    local res = {}
    for _, d in ipairs(vim.diagnostic.get(bufnr)) do
        res[d.severity] = (res[d.severity] or 0) + 1
    end

    local r_s = {}

    if res[vim.diagnostic.severity["HINT"]] ~= nil and res[vim.diagnostic.severity["HINT"]] > 0 then
        table.insert(r_s, string.format("%s%d", hint_icon, res[vim.diagnostic.severity["HINT"]]))
    end
    if res[vim.diagnostic.severity["INFO"]] ~= nil and res[vim.diagnostic.severity["INFO"]] > 0 then
        table.insert(r_s, string.format("%s%d", info_icon, res[vim.diagnostic.severity["INFO"]]))
    end
    if res[vim.diagnostic.severity["WARN"]] ~= nil and res[vim.diagnostic.severity["WARN"]] > 0 then
        table.insert(r_s, string.format("%s%d", warn_icon, res[vim.diagnostic.severity["WARN"]]))
    end
    if res[vim.diagnostic.severity["ERROR"]] ~= nil and res[vim.diagnostic.severity["ERROR"]] > 0 then
        table.insert(r_s, string.format("%s%d", err_icon, res[vim.diagnostic.severity["ERROR"]]))
    end
    if #r_s == 0 then
        return ""
    end
    return table.concat(r_s, " ")
end

function M.indentation()
    local spacetab = "Tab"
    local indents = vim.bo.tabstop
    if vim.bo.expandtab then
        spacetab = ""
        indents = vim.bo.softtabstop
        if indents < 0 then
            indents = vim.bo.shiftwidth
        end
    end
    local shifts = vim.bo.shiftwidth

    return spacetab .. " " .. indents .. ":" .. shifts
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

-- cache for tab labels.
-- key: tab number, value: tab label
local tabs_cache = {}

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

function M.tabs(noname_icon)
    if noname_icon == nil then
        noname_icon = "[無名]"
    end
    local current_tab = vim.fn.tabpagenr()
    local total_tabs = vim.fn.tabpagenr("$")

    local s = ""

    -- Add the tabs
    for i = 1, total_tabs do
        local is_current = i == current_tab
        if is_current then
            tabs_cache[i] = get_tab_label(i, true, noname_icon)
        end
        if tabs_cache[i] == nil then
            tabs_cache[i] = get_tab_label(i, false, noname_icon)
        end


        if is_current then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end
        s = s .. "%" .. i .. "T"
        s = s .. " " .. i .. ":" .. tabs_cache[i] .. " "
    end

    -- Fill the rest of the tabline
    s = s .. "%#TabLineFill#%T"

    return s
end

function M.default_active_status()
    local dyna_info = string.format(
        "%s %s %s %s",
        M.gitsigns_branch(),
        M.indentation(),
        M.file_encoding(),
        M.file_format()
    )

    vim.cmd([[
    		set rulerformat=%15(%c%V\ %p%%%)
    ]])

    local statusline = string.format(
        " %s %%<%%q%s%%m%%r%%h%%w %s%%= %s %%= %s %%-15(%%l,%%c%%V%%)%%P ",
        M.winnr(),
        M.filepath(),
        M.gitsigns_diff(),
        M.diagnostics(0),
        dyna_info
    )

    return statusline
end

function M.default_inactive_status()
    local statusline = string.format(
        " %s %%<%%q%s%%m%%r%%h%%w%%=  %%-15(%%l,%%c%%V%%)%%P ",
        M.winnr(),
        M.filepath()
    )

    return statusline
end

function M.default_tabline()
    return string.format(
        "%%#TabLineFill#%s: %s %%#TabLine#%s",
        M.cwd(),
        M.diagnostics(),
        M.tabs()
    )
end

return M
