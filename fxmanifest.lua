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
