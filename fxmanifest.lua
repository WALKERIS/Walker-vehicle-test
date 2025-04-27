server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
fx_version 'cerulean'
games {'gta5' }
lua54 'yes'

author 'WALKER'
description 'Walker TestVehicle script'
version '1.0.0'

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
    'entityiter.lua'
}
server_script {
    'server.lua'
}

ui_page 'html/timer.html'

files {
    'html/timer.html',
    'html/style.css',
    'html/script.js'
}