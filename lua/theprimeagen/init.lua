require("theprimeagen.set")
require("theprimeagen.remap")
require("theprimeagen.lazy_init")

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.guicursor = { 'i:ver25-blinkwait175-blinkoff150-blinkon175' }
vim.opt.cursorline = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set highlight on search
vim.o.hlsearch = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Leave at 10 lines when scrolling
vim.opt.scrolloff = 10

-- 4 spaces instead of tabs
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Indent when wrap and disable wrap
vim.opt.breakindent = true
vim.opt.wrap = false

-- Move through white spaces
vim.opt.backspace = { "start", "eol", "indent" }
-- vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })

-- Split right and below and keep cursor
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
--vim.cmd()
-- vim.opt.clipboard = 'unnamedplus'
-- vim.o.fillchars = "vert:|,horiz:━"

-- Copilot
-- Disable Copilot on startup
vim.g.copilot_enabled = false
-- vim.g.copilot_no_tab_map = true
-- vim.api.nvim_set_keymap('i', '<M-CR>', 'copilot#Accept("<CR>")', { expr = true, noremap = true, silent = true })
-- vim.keymap.set("i", "<C-CR>", function()
--     return vim.fn["copilot#Accept"]("<Tab>")
-- end, {
--     expr = true,
--     silent = true,
--     noremap = true
-- })

-- Keymaps to control it
vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", { silent = true })
vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", { silent = true })
--

ColorMyPencils()
