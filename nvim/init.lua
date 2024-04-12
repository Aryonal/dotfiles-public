if vim.g.vscode then
    -- VSCode extension
    -- require("vscode")
else
    _ = require("utils.loader").load("aryon")
end
