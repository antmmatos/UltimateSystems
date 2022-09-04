fx_version 'adamant'

game 'gta5'

Author 'SrD4rkOficial'

version '1.0'

lua54 'on'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'Configs/SCfg.lua',
    'Locales/*.lua',
	'src/Server/*.lua'
}

client_scripts {
    '@menuv/menuv.lua',
    'Configs/CCfg.lua',
	'src/Client/*.lua',
    'Locales/*.lua',
}

shared_scripts {
    'Blacklist/*.lua'
}

escrow_ignore {
    'Blacklist/*.lua',
    'Configs/SCfg.lua',
    'Configs/CCfg.lua',
    'Locales/*.lua'
}