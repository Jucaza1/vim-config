return{
"ThePrimeagen/git-worktree.nvim",
    name='git_worktree',
    dependencies={
        "nvim-telescope/telescope.nvim",
    },
    config=function ()
       require("git-worktree").setup({})
        require('telescope').load_extension("git_worktree")

        vim.keymap.set("n",'<leader>gt',
            '<CMD>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>')
        vim.keymap.set("n",'<leader>gr',
            '<CMD>lua require("telescope").extensions.create_git_worktree.git_worktree()<CR>')
    end
}
