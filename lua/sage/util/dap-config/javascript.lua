local M = {}

M.setup = function(dap)
	if not dap.adapters["pwa-node"] then
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					require("mason-registry").get_package("js-debug-adapter"):get_install_path()
					.. "/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}
	end

	for _, language in ipairs({ "typescript", "javascript" }) do
		if not dap.configurations[language] then
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "node",
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
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug Mocha Tests",
					-- trace = true, -- include debugger info
					runtimeExecutable = "node",
					runtimeArgs = {
						"./node_modules/mocha/bin/mocha.js",
					},
					rootPath = "${workspaceFolder}",
					cwd = "${workspaceFolder}",
					console = "integratedTerminal",
					internalConsoleOptions = "neverOpen",
				},
			}
		end
	end
end

return M
