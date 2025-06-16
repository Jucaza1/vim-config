return {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    config = function()
        require('crates').setup({
            lsp = {
                enabled = true,
                -- on_attach = function(client, bufnr)
                --     -- the same on_attach function as for your other language servers
                --     -- can be ommited if you're using the `LspAttach` autocmd
                -- end,
                actions = true,
                completion = true,
                hover = true,
            },
            completion = {
                cmp = {
                    enabled = true,
                },
                crates = {
                    enabled = true, -- disabled by default
                    max_results = 8, -- The maximum number of search results to display
                    min_chars = 3, -- The minimum number of charaters to type before completions begin appearing
                },
            },
        })
    end,
}
