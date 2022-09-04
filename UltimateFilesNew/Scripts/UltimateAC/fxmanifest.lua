fx_version 'cerulean'
games {'gta5'}

Author 'SrD4rkOficial'

server_scripts {'@mysql-async/lib/MySQL.lua', 'config/SCfg.lua', 'locales/*.lua', 'src/server/*.lua'}

client_scripts {'@menuv/menuv.lua', 'config/CCfg.lua', 'src/client/*.lua', 'locales/*.lua'}

shared_scripts {'blacklist/*.lua', 'src/shared/*.lua'}

escrow_ignore {'blacklist/*.lua', 'config/SCfg.lua', 'config/CCfg.lua', 'locales/*.lua'}

server_exports {'LoadBans', 'LogToDiscordBan'}

lua54 'on'
