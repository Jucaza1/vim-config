return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_browser = "/usr/bin/google-chrome"
    end,
    config = function()
        vim.keymap.set("n", "<Leader>mp", "<CMD>MarkdownPreview<CR>", { desc = "Markdown Preview" })
    end,
}
