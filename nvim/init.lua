if vim.g.vscode then
    -- VSCode extension
    -- require("vscode")
else
    require("utils.loader").load("aryon")
end
