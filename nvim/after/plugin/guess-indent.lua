local ok, gi = pcall(require, "guess-indent")
if ok then
    gi.setup {
        filetype_exclude = require("excluded-ft").extended_exclude,
    }
end
