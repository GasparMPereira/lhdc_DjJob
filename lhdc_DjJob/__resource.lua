resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'Emprego de DJ'
author 'Gaspar Pereira - gaspar#0880'
version '1.0.0'
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
	'esx_addonaccount',
	'skinchanger',
	'esx_skin'
}