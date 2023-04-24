fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_script '@ox_lib/init.lua'

client_script 'init.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'init.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/app.js',
    'html/fonts/*',

    'shared/config.lua',
    'client/main.lua',
    'client/modules/*.lua',
}

-- Load order of this resource is delegated to the required resources found in init.lua

lua54 'yes'