return {

    -- {
    --     "daic0r/dap-helper.nvim",
    --     dependencies = { "rcarriga/nvim-dap-ui", "mfussenegger/nvim-dap" },
    --     config = function()
    --         require("dap-helper").setup()
    --     end,
    -- },
    {
        'Weissle/persistent-breakpoints.nvim',
        config = function()
            require('persistent-breakpoints').setup {
                load_breakpoints_event = { "BufReadPost" }
            }
            vim.keymap.set("n", "<Leader>db", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>")
            vim.keymap.set("n", "<Leader>dc",
                "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>")
            vim.keymap.set("n", "<Leader>dl", "<cmd>lua require('persistent-breakpoints.api').set_log_point()<cr>")
        end
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            local dap = require("dap")
            dap.defaults.fallback.external_terminal = {
                command = "/usr/bin/kitty",
                args = { "--hold", "-e" },
            }

            local dapui = require("dapui")

            -- require("dap-python").setup()
            -- require("dap-python").setup("python3", { console = "externalTerminal" })
            require("dap-python").setup("python3", { console = "internalConsole" })
            require("dap-python").test_runner = "pytest"
            table.insert(require("dap").configurations.python, {
                justMyCode = false, -- <--- insert here
                type = "python",    -- the type here established the link to the adapter definition: `dap.adapters.python`
                request = "launch",
                name = "debug source code",
                program = "${file}",
            })

            table.insert(require("dap").configurations.python, {
                justMyCode = false, -- <--- insert here
                type = "python",    -- the type here established the link to the adapter definition: `dap.adapters.python`
                request = "launch",
                name = "debug AHEAD ui",
                program = "src/main.py",
                cwd = vim.fn.getcwd(),
                args = {
                    "--ui",
                },
                env = {
                    MAKELEVEL = "0",
                },
            })

            dap.listeners.before.attach.dapui_config = function()
                dapui.open({ layout = 4 }) -- open repl only
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open({ layout = 4 })
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            -- NOTE: this is set above
            -- vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, {})
            -- vim.keymap.set("n", "<Leader>dc", function()
            --     dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            -- end, {})
            -- vim.keymap.set("n", "<Leader>dc", dap.continue, {})

            vim.keymap.set("n", "<F5>", dap.continue, { desc = "dap start debugging or continue" })
            vim.keymap.set("n", "<F6>", dap.terminate, { desc = "dap terminate" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "dap step over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "dap step into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "dap step out" })

            vim.keymap.set("n", "<leader>dt", function()
                require("dap-python").test_method({ console = "internalConsole", config = { justMyCode = false } })
            end, { desc = "debug python test" })

            vim.keymap.set("n", "<Leader>dl", dap.run_last, {})

            -- dapui
            local widgets = require("dap.ui.widgets")

            vim.keymap.set("n", "<leader>dr", function()
                dapui.toggle({ layout = 4 })
            end, { desc = "Open DAP Repl" })

            vim.keymap.set("n", "<leader>ds", function()
                dapui.toggle({ layout = 3 })
            end, { desc = "Open DAP Scope" })

            vim.keymap.set("n", "<leader>df", function()
                dapui.toggle({ layout = 2 })
            end, { desc = "Open DAP Frame (Stacks)" })

            vim.keymap.set("n", "<leader>dw", function()
                dapui.toggle({ layout = 1 })
            end, { desc = "Open DAP Watches" })

            vim.keymap.set("n", "<leader>dh", widgets.hover, { desc = "DAP eval" })

            vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle debug ui" })

            vim.keymap.set("n", "<Leader>dp", function()
                dapui.float_element("breakpoints", { enter = true })
            end, { desc = "Toggle debug ui breakpoints" })

            vim.keymap.set("n", "<Leader>dR", function()
                dapui.float_element(
                    "repl",
                    { width = vim.o.columns - 10, height = vim.o.lines - 10, enter = true, position = "center" }
                )
            end, { desc = "Toggle float debug ui repl" })

            vim.keymap.set("n", "<Leader>dS", function()
                dapui.float_element(
                    "scopes",
                    { width = vim.o.columns - 10, height = vim.o.lines - 10, enter = true, position = "center" }
                )
            end, { desc = "Toggle float debug ui scopes" })

            vim.keymap.set("n", "<Leader>dW", function()
                dapui.float_element(
                    "watches",
                    { width = vim.o.columns - 10, height = vim.o.lines - 10, enter = true, position = "center" }
                )
            end, { desc = "Toggle float debug ui watches" })

            vim.keymap.set("n", "<Leader>dC", function()
                dapui.float_element(
                    "console",
                    { width = vim.o.columns - 10, height = vim.o.lines - 10, enter = true, position = "center" }
                )
            end, { desc = "Toggle float debug ui console" })

            local types_enabled = true
            local toggle_types = function()
                types_enabled = not types_enabled
                dapui.update_render({ max_type_length = types_enabled and -1 or 0 })
            end
            vim.keymap.set("n", "<Leader>dm", toggle_types, { desc = "toggle hide long types" })
            -- vim.keymap.set("n", "<Leader>ds", function()
            -- 	local widgets = require("dap.ui.widgets")
            -- 	widgets.centered_float(widgets.scopes)
            -- end, {})
        end,
    },

    {
        "leoluz/nvim-dap-go",
        dependencies = {
            { "mfussenegger/nvim-dap" },
            { "rcarriga/nvim-dap-ui" },
            { "nvim-neotest/nvim-nio" },
        },
        config = function()
            local dap_go = require("dap-go")
            local dap = require("dap")
            local dap_ui = require("dapui")
            --
            -- adapters configuration
            dap.adapters.go = {
                type = "server",
                host = "127.0.0.1",
                port = 37365,
                executable = {
                    command = "dlv",
                    args = { "dap", "--listen=127.0.0.1:37365", "--log" },
                },
            }

            local ts_utils = require("nvim-treesitter.ts_utils")

            local function get_current_function_name()
                local current_node = ts_utils.get_node_at_cursor()
                if not current_node then
                    return ""
                end

                local expr = current_node

                while expr do
                    print(expr.type())
                    if expr:type() == "function_definition" then
                        break
                    end
                    expr = expr:parent()
                end
                print(ts_utils.get_node_text(expr:child(1)))

                if not expr then
                    return ""
                end

                return (ts_utils.get_node_text(expr:child(1)))[1]
            end

            vim.keymap.set("n", "<leader>cf", get_current_function_name, { desc = "test capture function" })

            local function get_build_info()
                local handle = io.popen("date '+%F %T'")
                local build_time = handle:read("*a"):gsub("\n", ""):gsub(" ", "\\ ") -- Escape spaces
                handle:close()

                handle = io.popen("git rev-parse HEAD")
                local commit_sha1 = handle:read("*a"):gsub("\n", "")
                handle:close()

                return build_time, commit_sha1
            end

            local BUILD_TIME, COMMIT_SHA1 = get_build_info()

            dap_go.setup({
                dap_configurations = {
                    {
                        type = "go",
                        name = "Debug (KubeRay operator)",
                        request = "launch",
                        -- program = vim.fn.getcwd() .. "/bin/manager",
                        program = vim.fn.getcwd() .. "/" .. "main.go",
                        args = {
                            "-leader-election-namespace",
                            "default",
                            "-use-kubernetes-proxy",
                        },
                        -- buildFlags = "-ldflags " ..
                        --     "-X \"main._buildTime_=" .. BUILD_TIME .. "\" " ..
                        --     "-X \"main._commitId_=" .. COMMIT_SHA1 .. "\"",
                        cwd = vim.fn.getcwd(),
                        -- The -o bin/manager should be outside buildFlags, added here to ensure proper placement
                        -- buildCommand = "go build -o bin/manager main.go",
                    },
                    {
                        -- 	go run -race cmd/main.go -localSwaggerPath ${REPO_ROOT}/proto/swagger
                        -- 	NOTE: run from apiserver/
                        type = "go",
                        name = "Debug (KubeRay apiserver)",
                        request = "launch",
                        program = vim.fn.getcwd() .. "/" .. "cmd/main.go",
                        args = {
                            "-localSwaggerPath",
                            vim.fn.getcwd() .. "/proto/swagger"
                        },
                        cwd = vim.fn.getcwd(),
                    },
                    {
                        type = "go",
                        name = "Debug (Flyte default config)",
                        request = "launch",
                        program = vim.fn.getcwd() .. "/" .. "cmd",
                        args = {
                            "start",
                            "--config",
                            vim.fn.getcwd() .. "/" .. "flyte-single-binary-local.yaml",
                        },
                        env = {
                            POD_NAMESPACE = "flyte",
                        },
                        buildFlags = "-tags console -v",
                        cwd = vim.fn.getcwd(),
                    },
                    -- {
                    --     type = "go",
                    --     name = "Debug (Flyte Spark config)",
                    --     request = "launch",
                    --     program = vim.fn.getcwd() .. "/" .. "cmd",
                    --     args = {
                    --         "start",
                    --         "--config",
                    --         vim.fn.getcwd() .. "/" .. "../spark-values-override.yaml",
                    --     },
                    --     env = {
                    --         POD_NAMESPACE = "flyte",
                    --     },
                    --     buildFlags = "-tags console -v",
                    --     cwd = vim.fn.getcwd(),
                    -- },
                    -- {
                    --     type = "go",
                    --     name = "Debug (update workflow-execution-config)",
                    --     request = "launch",
                    --     mode = "debug",                      -- Use `debug` mode to run `go run` with debugging
                    --     program = vim.fn.getcwd() .. "/" .. "main.go",
                    --     args = {
                    --         "update",
                    --         "workflow-execution-config",
                    --         "--attrFile",
                    --         "../build/wec.yaml",
                    --     },
                    --     cwd = vim.fn.getcwd(), -- Use the current working directory
                    --     buildFlags = "", -- Add build flags if needed
                    -- },
                    -- {
                    --     type = "go",
                    --     name = "Debug (Flytectl input args)",
                    --     request = "launch",
                    --     mode = "debug",                      -- Use `debug` mode to run `go run` with debugging
                    --     program = vim.fn.getcwd() .. "/" .. "main.go",
                    --     args = function()
                    --         local args_input = vim.fn.input("Enter arguments (separated by spaces): ")
                    --         local args = {}
                    --         for arg in string.gmatch(args_input, "%S+") do
                    --             table.insert(args, arg)
                    --         end
                    --         return args
                    --     end,
                    --     cwd = vim.fn.getcwd(), -- Use the current working directory
                    --     buildFlags = "", -- Add build flags if needed
                    -- },
                    -- {
                    --     type = "go",
                    --     name = "Debug (Flytectl)",
                    --     request = "launch",
                    --     program = vim.fs.joinpath(vim.fn.getcwd(), "main.go"),
                    --     args = {
                    --         "demo",
                    --         "start",
                    --         "--disable-agent",
                    --         "--force",
                    --     },
                    --     -- env = {},
                    --     -- buildFlags = "-tags console -v",
                    --     cwd = vim.fn.getcwd(),
                    -- },
                    {
                        name = "Debug Test Current File",
                        type = "go",
                        request = "launch",
                        mode = "test",
                        -- cwd = "${fileDirname}", -- The directory of the current file
                        program = "${fileDirname}", -- Test the entire package where the file resides
                        -- program = "${file}", -- Current file with the test
                        showLog = true,
                        -- cwd = vim.fn.getcwd(),
                        -- dlvCwd = vim.fs.joinpath(vim.fn.getcwd(), "${fileDirname}"),
                        dlvCwd = "${fileDirname}",
                    },
                    {
                        type = "go",
                        name = "Debug Test Current File Specific Go Test",
                        request = "launch",
                        mode = "test",
                        -- program = "${file}", -- Current file with the test
                        program = "${fileDirname}", -- Test the entire package where the file resides
                        showLog = true,
                        -- dlvCwd = vim.fs.joinpath(vim.fn.getcwd(), "${fileDirname}"),
                        dlvCwd = "${fileDirname}",
                        -- args = { "-test.run", "^TestFunctionName$" }, -- Replace TestFunctionName dynamically
                        -- cwd = "./${relativeFileDirname}",
                        args = function()
                            -- Get the test name under the cursor
                            -- local test_name = get_current_function_name()
                            local test_name = vim.fn.expand("<cword>")
                            return { "-test.run", "^" .. test_name .. "$" }
                        end,
                    },
                },
            })

            vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
            vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
            vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

            vim.api.nvim_set_hl(0, "DapBreakpointLine", { ctermbg = 0, bg = "#31353f" })
            vim.api.nvim_set_hl(0, "DapLogPointLine", { ctermbg = 0, bg = "#31353f" })
            vim.api.nvim_set_hl(0, "DapStoppedLine", { ctermbg = 0, bg = "#31353f" })

            vim.fn.sign_define(
                "DapBreakpoint",
                { text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint" }
            )
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = "⭕", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint" }
            )
            vim.fn.sign_define(
                "DapBreakpointRejected",
                { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint" }
            )
            vim.fn.sign_define(
                "DapLogPoint",
                { text = "", texthl = "DapLogPoint", linehl = "DapLogPointLine", numhl = "DapLogPoint" }
            )
            vim.fn.sign_define(
                "DapStopped",
                { text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped" }
            )
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        opts = {
            layouts = {
                { -- 1
                    elements = {
                        {
                            id = "watches",
                            size = 1,
                        },
                    },
                    position = "left",
                    size = 40,
                },
                { -- 2
                    elements = {
                        {
                            id = "stacks",
                            size = 1,
                        },
                    },
                    position = "left",
                    size = 40,
                },
                { -- 3
                    elements = {
                        {
                            id = "scopes",
                            size = 1,
                        },
                    },
                    position = "left",
                    size = 40,
                },
                { -- 4
                    elements = {
                        {
                            id = "repl",
                            size = 1,
                        },
                    },
                    position = "bottom",
                    size = 15,
                },
                { -- 5
                    elements = {
                        {
                            id = "console",
                            size = 1,
                        },
                    },
                    position = "bottom",
                    size = 15,
                },
            },
            mappings = {
                edit = "e",
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                repl = "r",
                toggle = "t",
            },
            render = {
                indent = 1,
                max_value_lines = 100,
            },
        },
    },
}
