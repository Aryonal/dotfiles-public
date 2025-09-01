local M = {}

-- REF: https://github.com/nvim-lualine/lualine.nvim/blob/b8c23159c0161f4b89196f74ee3a6d02cdc3a955/lua/lualine/components/lsp_status.lua

---@type table<string, number>
local lsp_work_by_client_id = {}
---@type table<string, string>
local lsp_msg_by_client_id = {}

pcall(vim.api.nvim_create_autocmd, "LspProgress", {
    desc = "Update the Lualine LSP status component with progress",
    group = vim.api.nvim_create_augroup("lualine_lsp_progress", {}),
    ---@param event {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(event)
        local kind = event.data.params.value.kind
        local client_id = event.data.client_id
        local value = event.data.params.value

        local work = lsp_work_by_client_id[client_id] or 0
        local work_change = kind == "begin" and 1 or (kind == "end" and -1 or 0)

        lsp_work_by_client_id[client_id] = math.max(work + work_change, 0)

        -- Store the progress message
        local client_key = tostring(client_id)
        if kind == "begin" or kind == "report" then
            local message = value and value.title or ""
            if value and value.message then
                message = message .. (message ~= "" and ": " or "") .. value.message
            end
            if value and value.percentage then
                message = message .. " (" .. value.percentage .. "%)"
            end
            lsp_msg_by_client_id[client_key] = message
        elseif kind == "end" then
            -- Check if the end event has an error message
            if value and value.message and value.message:match("[Ee]rror") then
                lsp_msg_by_client_id[client_key] = "E:" .. value.message
            else
                lsp_msg_by_client_id[client_key] = nil
            end
        end

        vim.schedule(function()
            -- Force Lualine to re-render the statusline
            vim.cmd("redrawstatus")
        end)
    end,
})


---@param ctx customs.status.StatusContext
---@param opts customs.status.StatusOptions
function M.lsp_status(ctx, opts)
    local lsp_clients = vim.lsp.get_clients({ bufnr = ctx.buf })
    if #lsp_clients == 0 then
        return ""
    end

    if not ctx or not ctx.buf then
        return ""
    end

    local client_names = {}
    for _, client in ipairs(lsp_clients) do
        local name = client.name

        local skip = false
        for _, ignored in ipairs(opts.lsp_status.ignored) do
            if name:lower() == ignored:lower() then
                skip = true
                break
            end
        end

        if not skip then
            local work = lsp_work_by_client_id[client.id]
            local msg = lsp_msg_by_client_id[tostring(client.id)]

            if msg and msg ~= "" and opts.lsp_status.show_progress_msg then
                -- Show message (could be progress or error)
                if #msg > opts.lsp_status.progress_msg_length then
                    -- TODO: dynamically adjust length based on window width
                    msg = msg:sub(1, opts.lsp_status.progress_msg_length - 3) .. "…"
                end
                name = name .. " (" .. msg .. ")"
            elseif work ~= nil and work > 0 then
                -- in progress (with or without message when show_progress_msg is off)
                name = name .. " (working: " .. work .. ")"
            elseif work ~= nil and work == 0 then
                -- ready
                name = name .. opts.icons.lsp_ready
            end
            table.insert(client_names, name)
        end
    end

    if #client_names == 0 then
        return ""
    end

    return table.concat(client_names, ",")
end

return M
