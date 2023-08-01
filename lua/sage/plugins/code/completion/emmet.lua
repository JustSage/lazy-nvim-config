return {
	"mattn/emmet-vim",
	event = "VeryLazy",
	ft = { "html", "javascript", "ejs" },
	config = function()
		vim.g.user_emmet_mode = "a"
		vim.g.user_emmet_leader_key = ","
		vim.cmd([[
                    let g:user_emmet_settings = {
                    \  'variables': {'lang': 'en', 'charset': 'utf-8'},
                    \  'html': {
                    \    'default_attributes': {
                    \      'option': {'value': v:null},
                    \      'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows': 10},
                    \    },
                    \    'snippets': {
                    \      '!': "<!DOCTYPE html>\n"
                    \              ."<html lang=\"en\">\n"
                    \              ."<head>\n"
                    \              ."\t<meta charset=\"utf-8\">\n"
                    \              ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
                    \              ."\t<title>Document</title>\n"
                    \              ."\t<link rel=\"stylesheet\" href=\"css/styles.css\">\n"
                    \              ."</head>\n"
                    \              ."<body>\n\t${Insert HTML}|\n</body>\n"
                    \              ."</html>",
                    \    },
                    \  },
                    \}
        ]])
	end,
}