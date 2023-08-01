return {
	"mfussenegger/nvim-dap",
	keys = { "n", "<leader>b" },
	dependencies = {
		{ "mfussenegger/nvim-dap-python" },
		{ "theHamsta/nvim-dap-virtual-text" },
		{ "mxsdev/nvim-dap-vscode-js" },
		{
			"microsoft/vscode-js-debug",
			lazy = true,
			build = "npm install --legacy-peer-deps && npm run compile",
		},
	},
	config = function()
		local dap_status, dap = pcall(require, "dap")
		if not dap_status then
			return
		end

		local dapui_status, dapui = pcall(require, "dapui")
		if not dapui_status then
			return
		end

		require("dap-python").setup("$XDG_DATA_HOME/nvim/.virtualenvs/debugpy/bin/python")
		require("dap-python").test_runner = "pytest"

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		vim.fn.sign_define("DapBreakpoint", {
			text = " ",
			texthl = "ErrorMsg",
			linehl = "ErrorMsg",
			numhl = "ErrorMsg",
		})

		vim.fn.sign_define("DapLogPoint", {
			text = " ",
			texthl = "ErrorMsg",
			linehl = "ErrorMsg",
			numhl = "ErrorMsg",
		})

		vim.fn.sign_define("DapBreakpointCondition", {
			text = " ",
			texthl = "ErrorMsg",
			linehl = "ErrorMsg",
			numhl = "ErrorMsg",
		})

		vim.fn.sign_define("DapBreakpointRejected", {
			text = " ",
			texthl = "ErrorMsg",
			linehl = "ErrorMsg",
			numhl = "ErrorMsg",
		})

		vim.fn.sign_define("DapStopped", {
			text = " ",
			texthl = "ErrorMsg",
			linehl = "ErrorMsg",
			numhl = "ErrorMsg",
		})

		-- dap.adapters.node2 = {
		-- 	type = "executable",
		-- 	command = "node",
		-- 	args = { "~/.local/share/nvim/mason/packages/vscode-node-debug2/out/src/nodeDebug.js" },
		-- }
		-- dap.configurations.javascript = {
		-- 	{
		-- 		name = "Launch",
		-- 		type = "node2",
		-- 		request = "launch",
		-- 		program = "${file}",
		-- 		cwd = vim.fn.getcwd(),
		-- 		sourceMaps = true,
		-- 		protocol = "inspector",
		-- 		console = "integratedTerminal",
		-- 	},
		-- 	{
		-- 		-- For this to work you need to make sure the node process is started with the `--inspect` flag.
		-- 		name = "Attach to process",
		-- 		type = "node2",
		-- 		request = "attach",
		-- 		processId = require("dap.utils").pick_process,
		-- 	},
		-- }
		--
		dap.adapters.python = {
			type = "executable",
			command = { os.getenv("POETRY_HOME") },
			args = { "-m", "debugpy.adapter" },
		}

		dap.configurations.python = {
			{
				-- The first three options are required by nvim-dap
				type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
				request = "launch",
				name = "Launch file",
				-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

				program = "${file}", -- This configuration will launch the current file if used.
				pythonPath = function()
					-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
					-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
					-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
					local cwd = vim.fn.getcwd()
					if vim.fn.executable(cwd .. "/venv/bin/python3") == 1 then
						return cwd .. "/venv/bin/python3"
					elseif vim.fn.executable(cwd .. "/.venv/bin/python3") == 1 then
						return cwd .. "/.venv/bin/python3"
					else
						return "/usr/bin/python3"
					end
				end,
			},
		}

		require("dap-vscode-js").setup({
			node_path = "node",
			debugger_path = "/Users/sagebaram/.local/share/nvim/lazy/vscode-js-debug",
			-- debugger_cmd = { "js-debug-adapter" },
			adapters = { "pwa-node", "pwa-chrome", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
		})

		for _, language in ipairs({ "typescript", "javascript" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug Jest Tests",
					-- trace = true, -- include debugger info
					runtimeExecutable = "node",
					runtimeArgs = {
						"./node_modules/jest/bin/jest.js",
						"--runInBand",
					},
					rootPath = "${workspaceFolder}",
					cwd = "${workspaceFolder}",
					console = "integratedTerminal",
					internalConsoleOptions = "neverOpen",
				},
			}
		end
	end,
}
