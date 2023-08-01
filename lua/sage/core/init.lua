local modules = {
	"sage.core.options",
	"sage.core.mappings",
	"sage.core.functions",
	"sage.core.autocmds",
}

for _, module in ipairs(modules) do
	local pass, err = pcall(require, module)
	if not pass then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end
