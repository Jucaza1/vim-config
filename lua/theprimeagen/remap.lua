vim.g.mapleader = " "
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "", '<CMD>nohlsearch<CR>')

vim.keymap.set("n", "<leader>w", '<CMD>:update<CR>')
vim.keymap.set("n", "<leader>qq", '<CMD>:q<CR>')
vim.keymap.set("n", "<leader>Q", '<CMD>:qa<CR>')
-- vim.keymap.set("n", "gx", ":!open <c-r><c-a><CR>")
-- vim.keymap.set("v", "gx", "<CMD>!open '<,'><CR>")
-- Increment/decrement
vim.keymap.set("n", "<C-s>", "<C-a>", { desc = "Increment numbers", noremap = true })
-- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement numbers", noremap = true })
vim.keymap.set("n", "sv", ":split<Return>", opts)
vim.keymap.set("n", "ss", ":vsplit<Return>", opts)

vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sl", "<C-w>l")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")


vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set("n", "<leader>pp", [["+p]])
vim.keymap.set("n", "<leader>pp", [["*p]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["*y]])
-- vim.keymap.set("n", "<leader>Y", [["*Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "kj", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Quickfix keymaps
vim.keymap.set("n", "<leader>qo", ":copen<CR>") -- open quickfix list
-- vim.keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
-- vim.keymap.set("n", "<leader>qn", ":cnext<CR>") -- jump to next quickfix list item
-- vim.keymap.set("n", "<leader>qp", ":cprev<CR>") -- jump to prev quickfix list item
-- vim.keymap.set("n", "<leader>ql", ":clast<CR>") -- jump to last quickfix list item
vim.keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list
vim.keymap.set("n", "<C-y>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-t>", "<cmd>cprev<CR>zz")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set(
    "n",
    "<leader>ee",
    "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/dotfiles/nvim/.config/nvim/lua/theprimeagen/remap.lua<CR>");
vim.keymap.set("n", "<leader>obs", "<cmd>e ~/vaults/personal/main.md<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("so")
-- end)
