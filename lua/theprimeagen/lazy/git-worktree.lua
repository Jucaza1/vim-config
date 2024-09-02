return {
    "ThePrimeagen/git-worktree.nvim",
    name = 'git_worktree',
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("git-worktree").setup({})
        require('telescope').load_extension("git_worktree")

        vim.keymap.set("n", '<leader>gt',
            '<CMD>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>')
        vim.keymap.set("n", '<leader>gr',
            '<CMD>lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>')
        local Worktree = require("git-worktree")

        -- op = Operations.Switch, Operations.Create, Operations.Delete
        -- metadata = table of useful values (structure dependent on op)
        --      Switch
        --          path = path you switched to
        --          prev_path = previous worktree path
        --      Create
        --          path = path where worktree created
        --          branch = branch name
        --          upstream = upstream remote name
        --      Delete
        --          path = path where worktree deleted

        Worktree.on_tree_change(function(op, metadata)
            if op == Worktree.Operations.Switch then
                print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
            end
            if op == Worktree.Operations.Create then
                if nil ~= metadata.upstream then
                print("Created worktree for branch " .. metadata.branch .. " at " .. metadata.path .. " | upstream = " .. metadata.upstream )
                else
                print("Created worktree for branch " .. metadata.branch .. " at " .. metadata.path)
                end
            end
            if op == Worktree.Operations.Delete then
                print("Deleted worktree from " .. metadata.path)
            end
        end)
    end
}
