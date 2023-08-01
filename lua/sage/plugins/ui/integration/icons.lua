return {
	"nvim-tree/nvim-web-devicons",
	lazy = true,
	config = function()
		local icons = require("nvim-web-devicons")
		local defaults = icons.get_icons()

		local override = function(icon, name)
			return {
				name = defaults[name].name,
				color = defaults[name].color,
				cterm_color = defaults[name].cterm_color,
				icon = icon,
			}
		end
	end,
}

--     icons.setup({
--         override = {
--             c = override("", "c"),
--             html = override("", "html"),
--             css = override("", "css"),
--             js = override("", "js"),
--             ts = override("ﯤ", "ts"),
--             png = override("", "png"),
--             jpg = override("", "jpg"),
--             jpeg = override("", "jpeg"),
--             rb = override("", "rb"),
--             vue = override("﵂", "vue"),
--             py = override("", "py"),
--             toml = override("", "toml"),
--             lock = override("", "lock"),
--             lua = override("", "lua"),
--             md = override("", "markdown"),
--             Dockerfile = override("", "Dockerfile"),
--
--             -- Adding icons to source no cterm
--             default_icon = {
--                 icon = "",
--                 name = "Default",
--             },
--             zip = {
--                 icon = "",
--                 name = "zip",
--             },
--             xz = {
--                 icon = "",
--                 name = "xz",
--             },
--
--             mp3 = {
--                 icon = "",
--                 name = "mp3",
--             },
--
--             mp4 = {
--                 icon = "",
--                 name = "mp4",
--             },
--
--             out = {
--                 icon = "",
--                 name = "out",
--             },
--             xlsx = {
--                 icon = "",
--                 name = "excel",
--             },
--             csv = {
--                 icon = "",
--                 name = "csv",
--             },
--             ipynb = {
--                 icon = "",
--                 name = "ipynb",
--             },
--             ["robots.txt"] = {
--                 icon = "ﮧ",
--                 name = "robots",
--             },
--         },
--     })
-- end,
-- }
