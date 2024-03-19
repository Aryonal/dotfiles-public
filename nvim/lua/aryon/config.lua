local cfg = require("share.config")

local ok, _ = pcall(require, "aryon.patch.secret.config")
if ok then
    cfg = require("aryon.patch.secret.config")(cfg)
end

return cfg
