fx_version 'cerulean'
games {'gta5'}

files {'UI/ui.html', 'UI/script.js', 'UI/style.css', 'UI/sound_close.mp3', 'UI/sound_open.mp3', 'UI/sound_submit.mp3'}

ui_page 'UI/ui.html'

client_scripts {'config/client.lua', 'client/*.lua'}

server_scripts {'@mysql-async/lib/MySQL.lua', 'config/server.lua', 'licenses.lua', 'server/loader.lua',
                'server/server.lua', 'server/player.lua', 'server/common.lua', 'server/dev_server.lua',
                'server/classes/player.lua'}

server_exports {'GetUltimateObject', 'getAuth'}

exports {'GetUltimateObject', 'CreateDialog'}

escrow_ignore {'licenses.lua', 'config/*.lua', 'client/dev_client.lua', 'server/dev_server.lua'}

lua54 'yes'

client_script "@UltimateAC/src/Client/src_c_06.lua"