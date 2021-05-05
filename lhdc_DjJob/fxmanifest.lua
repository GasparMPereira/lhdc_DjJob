fx_version 'adamant'
game 'gta5'
version '1.0'
author 'Gaspar Pereira - gaspar#0880'
description 'Emprego de DJ'
ui_page 'html/ui.html'
server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}
dependencies {
	'es_extended',
	'skinchanger',
	'esx_skin'
}