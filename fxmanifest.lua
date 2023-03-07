fx_version 'cerulean'
game 'gta5'

description 'ESX Online Time'

version '1.0.0'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server.lua',
}

client_scripts {
    '@es_extended/locale.lua',
    'client.lua',
}

dependency { 
    'es_extended',
    'oxmysql',
}