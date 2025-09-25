local ok, other = pcall(require, "other-nvim")
if not ok then
    return
end

require("other-nvim").setup({
    mappings = {
        "livewire",
        "angular",
        "laravel",
        "rails",
        "golang",
        "python",
        "react",
        "rust",
        "elixir",
        "clojure",
    },
})
