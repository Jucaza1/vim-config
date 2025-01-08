local js_based_languages = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "vue",
}
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "mfussenegger/nvim-dap-python",
            "mxsdev/nvim-dap-vscode-js",
            {
                "microsoft/vscode-js-debug",
                -- After install, build it and rename the dist directory to out
                build =
                "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
                version = "1.*",
            },
            {
                "Joakker/lua-json5",
                build = "./install.sh",

            },
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        config = function()
            local dap = require "dap"
            local ui = require "dapui"

            require("dapui").setup()
            require("dap-go").setup()
            require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
            require("nvim-dap-virtual-text").setup({
                -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
                -- display_callback = function(variable)
                --   local name = string.lower(variable.name)
                --   local value = string.lower(variable.value)
                --   if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
                --     return "*****"
                --   end
                --
                --   if #variable.value > 15 then
                --     return " " .. string.sub(variable.value, 1, 15) .. "... "
                --   end
                --
                --   return " " .. variable.value
                -- end,
            })
            require("dap-vscode-js").setup({
                -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                -- node_path = "node",

                -- Path to vscode-js-debug installation.
                debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

                -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
                -- debugger_cmd = { "js-debug-adapter" },

                -- which adapters to register in nvim-dap
                adapters = {
                    "chrome",
                    "pwa-node",
                    "pwa-chrome",
                    "pwa-msedge",
                    "pwa-extensionHost",
                    "node-terminal",
                },
            })


            -- custom adapter for running tasks before starting debug
            local custom_adapter = 'pwa-node-custom'
            dap.adapters[custom_adapter] = function(cb, config)
                if config.preLaunchTask then
                    local async = require('plenary.async')
                    local notify = require('notify').async

                    async.run(function()
                        ---@diagnostic disable-next-line: missing-parameter
                        notify('Running [' .. config.preLaunchTask .. ']').events.close()
                    end, function()
                        vim.fn.system(config.preLaunchTask)
                        config.type = 'pwa-node'
                        dap.run(config)
                    end)
                end
            end

            if not dap.adapters["pwa-node"] then
                dap.adapters["pwa-node"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "node",
                        -- 💀 Make sure to update this path to point to your installation
                        args = {
                            vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
                            "${port}",
                        },
                    },
                }
            end
            if not dap.adapters["node"] then
                dap.adapters["node"] = function(cb, config)
                    if config.type == "node" then
                        config.type = "pwa-node"
                    end
                    local nativeAdapter = dap.adapters["pwa-node"]
                    if type(nativeAdapter) == "function" then
                        nativeAdapter(cb, config)
                    else
                        cb(nativeAdapter)
                    end
                end
            end
            local vscode = require("dap.ext.vscode")
            vscode.type_to_filetypes["node"] = js_based_languages
            vscode.type_to_filetypes["pwa-node"] = js_based_languages
            -- language config
            for _, language in ipairs(js_based_languages) do
                dap.configurations[language] = {
                    -- Debug single nodejs files
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = vim.fn.getcwd(),
                        sourceMaps = true,
                        skipFiles = { '<node_internals>/**' },
                        protocol = 'inspector',
                        console = 'integratedTerminal',
                    },
                    -- {
                    --     type = 'pwa-node',
                    --     request = 'launch',
                    --     name = 'typescript',
                    --     runtimeArgs = {
                    --         "--loader",
                    --         "ts-node/esm"
                    --     },
                    --     runtimeExecutable = "node",
                    --     args = {
                    --         "${file}"
                    --     },
                    --     resolveSourceMapLocations = {
                    --         '${workspaceFolder}/src/**/*.ts',
                    --     },
                    --     rootPath = '${workspaceFolder}',
                    --     cwd = '${workspaceFolder}',
                    --     sourceMaps = true,
                    --     skipFiles = { '<node_internals>/**' },
                    --     protocol = 'inspector',
                    --     console = 'integratedTerminal',
                    -- },
                    -- Debug nodejs processes (make sure to add --inspect when you run the process)
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require("dap.utils").pick_process,
                        cwd = vim.fn.getcwd(),
                        sourceMaps = true,
                        skipFiles = { '<node_internals>/**' },
                        protocol = 'inspector',
                        console = 'integratedTerminal',
                    },
                    -- Debug web applications (client side)
                    {
                        type = "pwa-chrome",
                        request = "launch",
                        name = "Launch & Debug Chrome",
                        url = function()
                            local co = coroutine.running()
                            return coroutine.create(function()
                                vim.ui.input({
                                    prompt = "Enter URL: ",
                                    default = "http://localhost:3000",
                                }, function(url)
                                    if url == nil or url == "" then
                                        return
                                    else
                                        coroutine.resume(co, url)
                                    end
                                end)
                            end)
                        end,
                        webRoot = vim.fn.getcwd(),
                        sourceMaps = true,
                        userDataDir = false,
                        skipFiles = { '<node_internals>/**' },
                        protocol = 'inspector',
                        console = 'integratedTerminal',
                    },
                    -- Divider for the launch.json derived configs
                    {
                        name = "----- ↓ launch.json configs ↓ -----",
                        type = "",
                        request = "launch",
                    },
                }
            end
            -- Handled by nvim-dap-go
            -- dap.adapters.go = {
            --   type = "server",
            --   port = "${port}",
            --   executable = {
            --     command = "dlv",
            --     args = { "dap", "-l", "127.0.0.1:${port}" },
            --   },
            -- }
            dap.adapters.codelldb = {
                type = "server",
                port = 2088,
                executable = {
                    command = "codelldb",
                    args = { "--port", "2088" }, -- Make sure to match the port if needed
                },
            }

            dap.configurations.rust = {
                {
                    name = "Launch",
                    type = "codelldb", -- Use the codelldb adapter
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {}, -- Optional: provide arguments to your program
                    runInTerminal = false,
                }
            }
            -- local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
            -- if elixir_ls_debugger ~= "" then
            --     dap.adapters.mix_task = {
            --         type = "executable",
            --         command = elixir_ls_debugger,
            --     }
            --
            --     dap.configurations.elixir = {
            --         {
            --             type = "mix_task",
            --             name = "phoenix server",
            --             task = "phx.server",
            --             request = "launch",
            --             projectDir = "${workspaceFolder}",
            --             exitAfterTaskReturns = false,
            --             debugAutoInterpretAllModules = false,
            --         },
            --     }
            -- end
            -- dap.configurations.python = {
            --     {
            --         type = 'python',
            --         request = 'launch',
            --         name = "Launch file",
            --         program = "${file}",
            --         pythonPath = function()
            --             return '/usr/bin/python3'
            --         end,
            --     },
            -- }

            local function find_main_class()
                local main_class = vim.fn.expand('%:p') -- Get current file path
                local is_file = vim.fn.filereadable(current_file) == 1
                if not is_file then
                    return nil
                end

                -- Check if the current file has the main method
                local has_main = false
                for line in io.lines(main_class) do
                    if line:find('public static void main') then
                        has_main = true
                        break
                    end
                end

                if has_main then
                    -- If the current file has a main method, return it as the main class
                    return main_class
                else
                    -- Optionally, search your workspace (e.g., via 'find' command) for Java classes with main
                    -- You could integrate a more complex solution here for workspace-wide search
                    return nil
                end
            end
            local main_class = find_main_class()
            dap.configurations['java'] = {
                {
                    type = 'java',
                    request = 'launch',
                    name = 'Launch Java Program',
                    mainClass = main_class, -- Path to the main class or use `${workspaceFolder}`
                    projectName = '',       -- Optional: specify the project name if using a multi-project workspace
                },
            }
            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

            -- Eval var under cursor
            vim.keymap.set("n", "<space>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.keymap.set("n", "<F1>", function()
                if vim.fn.filereadable(".vscode/launch.json") then
                    local dap_vscode = require("dap.ext.vscode")
                    dap_vscode.load_launchjs(nil, {
                        ["pwa-node"] = js_based_languages,
                        ["chrome"] = js_based_languages,
                        ["pwa-chrome"] = js_based_languages,
                    })
                end
                dap.continue()
            end)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)
            vim.keymap.set("n", "<F8>", dap.terminate)
            vim.keymap.set("n", "<F9>", dap.restart)

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
