-- Java Language Server configuration.
-- Locations:
-- 'nvim/ftplugin/java.lua'.
-- 'nvim/lang-servers/intellij-java-google-style.xml'

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
    vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
    return
end

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local jdtls_path = vim.fn.stdpath('data') .. "/mason/packages/jdtls/"
local path_to_lsp_server = jdtls_path .. "/config_linux"
local path_to_plugins = jdtls_path .. "plugins/"
-- local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher.gtk.linux.aarch64_1.2.1100.v20240722-2106.jar"
local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"
local lombok_path = jdtls_path .. "lombok.jar"
-- local lombok_path = vim.fn.expand("~/.config/nvim/java_jars/") .. "lombok.jar"

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
    return
end
local home_dir = vim.env.HOME
local bundles = {
    vim.fn.glob(home_dir .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(home_dir .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
os.execute("mkdir " .. workspace_dir)

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
--   -- Add diagnostics to the location list instead of showing floating window
--   vim.diagnostic.setloclist({
--     open = false,  -- Don't automatically open the location list
--   })
-- end

local home = vim.fn.expand("~/.asdf/installs/java/");
-- Main Config
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        vim.fn.expand("~/.asdf/shims/java"),
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. lombok_path,
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        '-jar', path_to_jar,
        '-configuration', path_to_lsp_server,
        '-data', workspace_dir,
    },

    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = root_dir,

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    --
    -- home = vim.fn.expand("~/.asdf/installs/java/adoptopenjdk-18.0.2+9/bin/java"),
    -- eclipse = {
    --     downloadSources = true,
    -- },
    -- configuration = {
    --     updateBuildConfiguration = "interactive",
    --     runtimes = {
    --         {
    --             name = "JavaSE-18",
    --             path = vim.fn.expand("~/.asdf/installs/java/adoptopenjdk-18.0.2+101/"),
    --         },
    --         -- {
    --         --   name = "JavaSE-17",
    --         --   path = "/Users/ivanermolaev/Library/Java/JavaVirtualMachines/temurin-17.0.4/Contents/Home",
    --         -- }
    --     }
    -- },
    settings = {
        java = {
            home = vim.fn.expand("~/.asdf/shims/java"),
            -- home = vim.fn.expand("~/.asdf/installs/java/adoptopenjdk-18.0.2+9/bin/java"),
            -- home = vim.fn.expand("~/.asdf/installs/java/"),
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    {
                        name = "JavaSE-17",
                        path = home .. "openjdk-17/",
                    },
                    {
                        name = "JavaSE-18",
                        path = home .. "adoptopenjdk-18.0.2+101/",
                    }
                }
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            format = {
                enabled = true,
                settings = {
                    url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },

        },
        signatureHelp = { enabled = true },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
            importOrder = {
                "java",
                "javax",
                "com",
                "org"
            },
        },
        -- extendedClientCapabilities = extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },

    flags = {
        allow_incremental_sync = true,
    },
    bundles = bundles,

    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    init_options = {
        -- References the bundles defined above to support Debugging and Unit Testing
        bundles = bundles,
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },
    -- init_options = {
    --     bundles = {},
    -- },
}

config['on_attach'] = function(client, bufnr)
    require "lsp_signature".on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        floating_window_above_cur_line = false,
        padding = '',
        handler_opts = {
            border = "rounded"
        }
    }, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
  require("jdtls.dap").setup_dap_main_class_configs()
    -- require('jdtls.dap').setup_dap()
    --
    --     -- Find the main method(s) of the application so the debug adapter can successfully start up the application
    --     -- Sometimes this will randomly fail if language server takes to long to startup for the project, if a ClassDefNotFoundException occurs when running
    --     -- the debug tool, attempt to run the debug tool while in the main class of the application, or restart the neovim instance
    --     -- Unfortunately I have not found an elegant way to ensure this works 100%
    --     require('jdtls.dap').setup_dap_main_class_configs()
    --     -- Enable jdtls commands to be used in Neovim
    --     require 'jdtls.setup'.add_commands()
    --     -- Refresh the codelens
    --     -- Code lens enables features such as code reference counts, implemenation counts, and more.
    vim.lsp.codelens.refresh()

    -- Setup a function that automatically runs every time a java file is saved to refresh the code lens
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.java" },
        callback = function()
            local _, _ = pcall(vim.lsp.codelens.refresh)
        end
    })
end
-- require('jdtls.dap').setup_dap()

-- Find the main method(s) of the application so the debug adapter can successfully start up the application
-- Sometimes this will randomly fail if language server takes to long to startup for the project, if a ClassDefNotFoundException occurs when running
-- the debug tool, attempt to run the debug tool while in the main class of the application, or restart the neovim instance
-- Unfortunately I have not found an elegant way to ensure this works 100%
-- require('jdtls.dap').setup_dap_main_class_configs()
-- Enable jdtls commands to be used in Neovim
-- require 'jdtls.setup'.add_commands()
-- local dap = require('dap')
-- local function find_main_class()
--     local main_class = vim.fn.expand('%:p') -- Get current file path
--
--     -- Check if the current file has the main method
--     local has_main = false
--     for line in io.lines(main_class) do
--         if line:find('public static void main') then
--             has_main = true
--             break
--         end
--     end
--
--     if has_main then
--         -- If the current file has a main method, return it as the main class
--         return main_class
--     else
--         -- Optionally, search your workspace (e.g., via 'find' command) for Java classes with main
--         -- You could integrate a more complex solution here for workspace-wide search
--         return nil
--     end
-- end
-- local main_class = find_main_class()
-- dap.configurations.java = {
--     {
--         type = 'java',
--         request = 'launch',
--         name = 'Launch Java Program',
--         mainClass = main_class, -- Path to the main class or use `${workspaceFolder}`
--         projectName = '',       -- Optional: specify the project name if using a multi-project workspace
--     },
-- }

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
--SPRING_BOOT
-- local springboot_nvim = require("springboot-nvim")
--
-- -- set a vim motion to <Space> + <Shift>J + r to run the spring boot project in a vim terminal
-- vim.keymap.set('n', '<leader>jr', springboot_nvim.boot_run, { desc = "[J]ava [R]un Spring Boot" })
-- -- set a vim motion to <Space> + <Shift>J + c to open the generate class ui to create a class
-- vim.keymap.set('n', '<leader>jc', springboot_nvim.generate_class, { desc = "[J]ava Create [C]lass" })
-- -- set a vim motion to <Space> + <Shift>J + i to open the generate interface ui to create an interface
-- vim.keymap.set('n', '<leader>ji', springboot_nvim.generate_interface, { desc = "[J]ava Create [I]nterface" })
-- -- set a vim motion to <Space> + <Shift>J + e to open the generate enum ui to create an enum
-- vim.keymap.set('n', '<leader>je', springboot_nvim.generate_enum, { desc = "[J]ava Create [E]num" })
--
-- -- run the setup function with default configuration
-- springboot_nvim.setup({})
