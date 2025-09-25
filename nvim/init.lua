vim.g.mapleader = ","

-- vim.g.debug = true

if vim.g.debug then print("[debug] sourcing init.lua") end

require("load-config")
require("mini-deps-bootstrap")
-- require("rocks-bootstrap")

require("load-exrc")
