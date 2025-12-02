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
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
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
                    element_mappings = {},
                    floating = {
                        border = "single",
                        mappings = {
                            close = { "q", "<Esc>" },
                        },
                    },
                    windows = { indent = 1 },
                },
                config = function(_, opts)
                    local dapui = require("dapui")
                    dapui.setup(opts)

                    -- Enable line wrapping for REPL window
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = "dapui_repl",
                        callback = function()
                            vim.opt_local.wrap = true
                            vim.opt_local.linebreak = true
                        end,
                    })
                end,
            },
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
                dapui.open({ layout = 4 }) -- open repl
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open({ layout = 4 }) -- open repl
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                -- Don't close - keeps test output visible in console after test ends
            end
            dap.listeners.before.event_exited.dapui_config = function()
                -- Don't close - keeps test output visible in console after test ends
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

            -- Python test debugging - filetype specific
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "python",
                callback = function()
                    vim.keymap.set("n", "<leader>dt", function()
                        require("dap-python").test_method({ console = "internalConsole", config = { justMyCode = false } })
                    end, { desc = "debug python test", buffer = true })
                end,
            })

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
            -- Use port = ${port} to let dlv pick a random free port
            -- This allows multiple simultaneous debug sessions
            dap.adapters.go = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "dlv",
                    args = { "dap", "-l", "127.0.0.1:${port}" },
                    -- detached = false means the debug adapter will be killed when nvim exits
                    detached = vim.fn.has("win32") == 0,
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

            -- Helper function to detect build tags in current file
            local function get_build_tags()
                local file_path = vim.fn.expand("%:p")
                local file = io.open(file_path, "r")
                if not file then return "" end

                -- Read first 10 lines to find build tags
                local tags = {}
                for i = 1, 10 do
                    local line = file:read("*l")
                    if not line then break end

                    -- Match //go:build tag1,tag2 or // +build tag1 tag2
                    local build_constraint = line:match("^//go:build%s+(.+)") or line:match("^//%s*%+build%s+(.+)")
                    if build_constraint then
                        -- Parse tags (handle AND, OR, NOT logic)
                        for tag in build_constraint:gmatch("[%w_]+") do
                            table.insert(tags, tag)
                        end
                    end
                end
                file:close()

                if #tags > 0 then
                    return "-tags=" .. table.concat(tags, ",")
                end
                return ""
            end

            -- Helper function to get test function name using treesitter
            local function get_go_test_name()
                local ts_utils = require("nvim-treesitter.ts_utils")
                local current_node = ts_utils.get_node_at_cursor()
                if not current_node then
                    return nil
                end

                -- Walk up the tree to find function_declaration
                local expr = current_node
                while expr do
                    if expr:type() == "function_declaration" then
                        -- Get the function name
                        for child in expr:iter_children() do
                            if child:type() == "identifier" then
                                local name = vim.treesitter.get_node_text(child, 0)
                                -- Only return if it's a test function (starts with Test)
                                if name:match("^Test") then
                                    return name
                                end
                            end
                        end
                    end
                    expr = expr:parent()
                end

                -- Fallback: try to get word under cursor if it looks like a test
                local word = vim.fn.expand("<cword>")
                if word:match("^Test") then
                    return word
                end

                return nil
            end

            -- Go test debugging - filetype specific
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "go",
                callback = function()
                    vim.keymap.set("n", "<leader>dt", function()
                        local test_name = get_go_test_name()
                        local build_flags = get_build_tags()

                        local config = {
                            type = "go",
                            name = "Debug Test",
                            request = "launch",
                            mode = "test",
                            program = "${fileDirname}",
                            dlvCwd = "${fileDirname}",
                            showLog = true,
                        }

                        -- Add test filter if we found a test name
                        if test_name and test_name ~= "" then
                            config.args = { "-test.run", "^" .. test_name .. "$" }
                            config.name = "Debug Test: " .. test_name
                        else
                            -- Run all tests in the file if no specific test found
                            config.args = {}
                            config.name = "Debug All Tests"
                            vim.notify("No test function found under cursor, running all tests", vim.log.levels.WARN)
                        end

                        -- Only add buildFlags if tags were found
                        if build_flags ~= "" then
                            config.buildFlags = build_flags
                        end

                        dap.run(config)
                    end, { desc = "debug go test (auto-detect tags)", buffer = true })
                end,
            })

            -- List and switch between active debug sessions
            vim.keymap.set("n", "<leader>dL", function()
                local sessions = dap.sessions()
                if vim.tbl_isempty(sessions) then
                    vim.notify("No active debug sessions", vim.log.levels.WARN)
                    return
                end

                local items = {}
                for session_id, session in pairs(sessions) do
                    local config = session.config
                    table.insert(items, {
                        text = string.format("[%d] %s", session_id, config.name or "Unnamed"),
                        session_id = session_id,
                    })
                end

                vim.ui.select(items, {
                    prompt = "Select debug session:",
                    format_item = function(item)
                        return item.text
                    end,
                }, function(choice)
                    if choice then
                        dap.set_session(dap.sessions()[choice.session_id])
                        vim.notify("Switched to session: " .. choice.text, vim.log.levels.INFO)
                    end
                end)
            end, { desc = "list and switch debug sessions" })

            -- Show active debug sessions count
            vim.keymap.set("n", "<leader>dI", function()
                local sessions = dap.sessions()
                local count = 0
                local names = {}
                for _, session in pairs(sessions) do
                    count = count + 1
                    table.insert(names, session.config.name or "Unnamed")
                end

                if count == 0 then
                    vim.notify("No active debug sessions", vim.log.levels.INFO)
                else
                    vim.notify(string.format("%d active session(s):\n- %s", count, table.concat(names, "\n- ")), vim.log.levels.INFO)
                end
            end, { desc = "show debug session info" })

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
                    {
                        type = "go",
                        name = "Debug (Cloud Devbox)",
                        request = "launch",
                        program = vim.fn.getcwd() .. "/" .. "devbox/main.go",
                        args = {
                            "start",
                            "--config",
                            vim.fn.getcwd() .. "/" .. "devbox/local.yaml",
                        },
                        env = {
                            AWS_ENDPOINT_URL = "http://localhost:4566",
                        },
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
}
