local IS_SERVER = IsDuplicityVersion()
local table_unpack = table.unpack
local debug = debug
local debug_getinfo = debug.getinfo
local msgpack = msgpack
local msgpack_pack = msgpack.pack
local msgpack_unpack = msgpack.unpack
local msgpack_pack_args = msgpack.pack_args
local PENDING = 0
local REJECTING = 2
local REJECTED = 4

local function ensure(obj, typeof, opt_typeof, errMessage)
	local objtype = type(obj)
	local di = debug_getinfo(2)
	local errMessage = errMessage or (opt_typeof == nil and (di.name .. ' expected %s, but got %s') or (di.name .. ' expected %s or %s, but got %s'))
	if typeof ~= 'function' then
		if objtype ~= typeof and objtype ~= opt_typeof then
			error((errMessage):format(typeof, (opt_typeof == nil and objtype or opt_typeof), objtype))
		end
	else
		if objtype == 'table' and not rawget(obj, '__cfx_functionReference') then
			error((errMessage):format(typeof, (opt_typeof == nil and objtype or opt_typeof), objtype))
		end
	end
end

SetInterval = setmetatable({currentId = 0}, {
	__call = function(self, callback, timer)
		local id = self.currentId + 1
		self.currentId = id
		self[id] = timer or 0
		CreateThread(function()
			repeat
				local interval = self[id]
				Wait(interval)
				callback(interval)
			until interval == -1
			self[id] = nil
		end)
		return id
	end
})


function inTable(table, item)
	for _,v in pairs(table) do
		if v == item then return true end
	end
	return false
end

function inTableHash(table, item)
	for _,v in pairs(table) do
		if GetHashKey(v) == item then return true end
	end
	return false
end

function TableCompare(a,b)
	local t1,t2 = {}, {}
	for k,v in pairs(a) do
		t1[k] = (t1[k] or 0) + 1
	end
	for k,v in pairs(b) do
		t2[k] = (t2[k] or 0) + 1
	end
	for k,v in pairs(t2) do
		if v ~= t1[k] then return false end
	end
	return true
end


if IS_SERVER then
	_G.RegisterServerCallback = function(args)
		ensure(args, 'table'); ensure(args.eventName, 'string'); ensure(args.eventCallback, 'function')
		local eventCallback = args.eventCallback
		local eventName = args.eventName
		local eventData = RegisterNetEvent('Ultimate__server_callback:'..eventName, function(packed, src, cb)
			local source = tonumber(source)
			if not source then
				cb( msgpack_pack_args( eventCallback(src, table_unpack(msgpack_unpack(packed)) ) ) )
			else
				TriggerClientEvent(('Ultimate__client_callback_response:%s:%s'):format(eventName, source), source, msgpack_pack_args( eventCallback(source, table_unpack(msgpack_unpack(packed)) ) ))
			end
		end)
		return eventData
	end
	_G.UnregisterServerCallback = function(eventData)
		RemoveEventHandler(eventData)
	end
	_G.TriggerClientCallback = function(args)
		ensure(args, 'table'); ensure(args.source, 'string', 'number'); ensure(args.eventName, 'string'); ensure(args.args, 'table', 'nil'); ensure(args.timeout, 'number', 'nil'); ensure(args.timedout, 'function', 'nil'); ensure(args.callback, 'function', 'nil')
		if tonumber(args.source) >= 0 then
			local ticket = tostring(args.source) .. 'x' .. tostring(GetGameTimer())
			local prom = promise.new()
			local eventCallback = args.callback
			local eventData = RegisterNetEvent(('Ultimate__callback_retval:%s:%s:%s'):format(args.source, args.eventName, ticket), function(packed)
				if eventCallback and prom.state == PENDING then eventCallback( table_unpack(msgpack_unpack(packed)) ) end
				prom:resolve( table_unpack(msgpack_unpack(packed)) )
			end)
			TriggerClientEvent(('Ultimate__client_callback:%s'):format(args.eventName), args.source, msgpack_pack(args.args or {}), ticket)
			if args.timeout ~= nil and args.timedout then
				local timedout = args.timedout
				SetTimeout(args.timeout * 1000, function()
					if
						prom.state == PENDING or
						prom.state == REJECTED or
						prom.state == REJECTING
					then
						timedout(prom.state)
						if prom.state == PENDING then prom:reject() end
						RemoveEventHandler(eventData)
					end
				end)
			end
			if not eventCallback then
				local result = Citizen.Await(prom)
				RemoveEventHandler(eventData)
				return result
			end
		else
			error 'source should be equal too or higher than 0'
		end
	end
	_G.TriggerServerCallback = function(args)
		ensure(args, 'table'); ensure(args.source, 'string', 'number'); ensure(args.eventName, 'string'); ensure(args.args, 'table', 'nil'); ensure(args.timeout, 'number', 'nil'); ensure(args.timedout, 'function', 'nil'); ensure(args.callback, 'function', 'nil')
		local prom = promise.new()
		local eventCallback = args.callback
		local eventName = args.eventName
		TriggerEvent('Ultimate__server_callback:'..eventName, msgpack_pack(args.args or {}), args.source,
		function(packed)
			if eventCallback and prom.state == PENDING then eventCallback( table_unpack(msgpack_unpack(packed)) ) end
			prom:resolve( table_unpack(msgpack_unpack(packed)) )
		end)

		if args.timeout ~= nil and args.timedout then
			local timedout = args.timedout
			SetTimeout(args.timeout * 1000, function()
				if
					prom.state == PENDING or
					prom.state == REJECTED or
					prom.state == REJECTING
				then
					timedout(prom.state)
					if prom.state == PENDING then prom:reject() end
				end
			end)
		end
		if not eventCallback then
			return Citizen.Await(prom)
		end
	end
end


if not IS_SERVER then
	local SERVER_ID = GetPlayerServerId(PlayerId())
	_G.RegisterClientCallback = function(args)
		ensure(args, 'table'); ensure(args.eventName, 'string'); ensure(args.eventCallback, 'function')
		local eventCallback = args.eventCallback
		local eventName = args.eventName
		local eventData = RegisterNetEvent('Ultimate__client_callback:'..eventName, function(packed, ticket)
			if type(ticket) == 'function' then
				ticket( msgpack_pack_args( eventCallback( table_unpack(msgpack_unpack(packed)) ) ) )
			else
				TriggerServerEvent(('Ultimate__callback_retval:%s:%s:%s'):format(SERVER_ID, eventName, ticket), msgpack_pack_args( eventCallback( table_unpack(msgpack_unpack(packed)) ) ))
			end
		end)
		return eventData
	end
	_G.UnregisterClientCallback = function(eventData)
		RemoveEventHandler(eventData)
	end
	_G.TriggerServerCallback = function(args)
		ensure(args, 'table'); ensure(args.args, 'table', 'nil'); ensure(args.eventName, 'string'); ensure(args.timeout, 'number', 'nil'); ensure(args.timedout, 'function', 'nil'); ensure(args.callback, 'function', 'nil')
		local prom = promise.new()
		local eventCallback = args.callback
		local eventData = RegisterNetEvent(('Ultimate__client_callback_response:%s:%s'):format(args.eventName, SERVER_ID),
		function(packed)
			if eventCallback and prom.state == PENDING then eventCallback( table_unpack(msgpack_unpack(packed)) ) end
			prom:resolve( table_unpack(msgpack_unpack(packed)) )
		end)
		TriggerServerEvent('Ultimate__server_callback:'..args.eventName, msgpack_pack( args.args ))
		if args.timeout ~= nil and args.timedout then
			local timedout = args.timedout
			SetTimeout(args.timeout * 1000, function()
				if
					prom.state == PENDING or
					prom.state == REJECTED or
					prom.state == REJECTING
				then
					timedout(prom.state)
					if prom.state == PENDING then prom:reject() end
					RemoveEventHandler(eventData)
				end
			end)
		end
		if not eventCallback then
			local result = Citizen.Await(prom)
			RemoveEventHandler(eventData)
			return result
		end
	end
	_G.TriggerClientCallback = function(args)
		ensure(args, 'table'); ensure(args.eventName, 'string'); ensure(args.args, 'table', 'nil'); ensure(args.timeout, 'number', 'nil'); ensure(args.timedout, 'function', 'nil'); ensure(args.callback, 'function', 'nil')
		local prom = promise.new()
		local eventCallback = args.callback
		local eventName = args.eventName
		TriggerEvent('Ultimate__client_callback:'..eventName, msgpack_pack(args.args or {}),
		function(packed)
			if eventCallback and prom.state == PENDING then eventCallback( table_unpack(msgpack_unpack(packed)) ) end
			prom:resolve( table_unpack(msgpack_unpack(packed)) )
		end)
		if args.timeout ~= nil and args.timedout then
			local timedout = args.timedout
			SetTimeout(args.timeout * 1000, function()
				if
					prom.state == PENDING or
					prom.state == REJECTED or
					prom.state == REJECTING
				then
					timedout(prom.state)
					if prom.state == PENDING then prom:reject() end
				end
			end)
		end
		if not eventCallback then
			return Citizen.Await(prom)
		end
	end
end

ListWeapons = {
	'weapon_advancedrifle',
	'weapon_appistol',
	'weapon_assaultrifle',
	'weapon_assaultrifle_mk2',
	'weapon_assaultshotgun',
	'weapon_assaultsmg',
	'weapon_autoshotgun',
	'weapon_bat',
	'weapon_ball',
	'weapon_battleaxe',
	'weapon_bottle',
	'weapon_bullpuprifle',
	'weapon_bullpuprifle_mk2',
	'weapon_bullpupshotgun',
	'weapon_bzgas',
	'weapon_carbinerifle',
	'weapon_carbinerifle_mk2',
	'weapon_combatmg',
	'weapon_combatmg_mk2',
	'weapon_combatpdw',
	'weapon_combatpistol',
	'weapon_compactlauncher',
	'weapon_compactrifle',
	'weapon_crowbar',
	'weapon_dagger',
	'weapon_dbshotgun',
	'weapon_doubleaction',
	'weapon_fireextinguisher',
	'weapon_firework',
	'weapon_flare',
	'weapon_flaregun',
	'weapon_flashlight',
	'weapon_golfclub',
	'weapon_grenade',
	'weapon_grenadelauncher',
	'weapon_gusenberg',
	'weapon_hammer',
	'weapon_hatchet',
	'weapon_heavypistol',
	'weapon_heavyshotgun',
	'weapon_heavysniper',
	'weapon_heavysniper_mk2',
	'weapon_hominglauncher',
	'weapon_knife',
	'weapon_knuckle',
	'weapon_machete',
	'weapon_machinepistol',
	'weapon_marksmanpistol',
	'weapon_marksmanrifle',
	'weapon_marksmanrifle_mk2',
	'weapon_mg',
	'weapon_microsmg',
	'weapon_minigun',
	'weapon_minismg',
	'weapon_molotov',
	'weapon_musket',
	'weapon_nightstick',
	'weapon_pipebomb',
	'weapon_pistol',
	'weapon_pistol50',
	'weapon_pistol_mk2',
	'weapon_poolcue',
	'weapon_proxmine',
	'weapon_pumpshotgun',
	'weapon_pumpshotgun_mk2',
	'weapon_railgun',
	'weapon_revolver',
	'weapon_revolver_mk2',
	'weapon_rpg',
	'weapon_sawnoffshotgun',
	'weapon_smg',
	'weapon_smg_mk2',
	'weapon_smokegrenade',
	'weapon_sniperrifle',
	'weapon_snowball',
	'weapon_snspistol',
	'weapon_snspistol_mk2',
	'weapon_specialcarbine',
	'weapon_specialcarbine_mk2',
	'weapon_stickybomb',
	'weapon_stungun',
	'weapon_switchblade',
	'weapon_vintagepistol',
	'weapon_wrench',
	'weapon_raypistol',
	'weapon_raycarbine',
	'weapon_rayminigun',
	'weapon_stone_hatchet',
}

ListWeaponsHashes = {
    GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01'),
    GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02'),
    GetHashKey('COMPONENT_APPISTOL_CLIP_01'),
    GetHashKey('COMPONENT_APPISTOL_CLIP_02'),
    GetHashKey('COMPONENT_MICROSMG_CLIP_01'),
    GetHashKey('COMPONENT_MICROSMG_CLIP_02'),
    GetHashKey('COMPONENT_SMG_CLIP_01'),
    GetHashKey('COMPONENT_SMG_CLIP_02'),
    GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02'),
    GetHashKey('COMPONENT_CARBINERIFLE_CLIP_01'),
    GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02'),
    GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_01'),
    GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02'),
    GetHashKey('COMPONENT_MG_CLIP_01'),
    GetHashKey('COMPONENT_MG_CLIP_02'),
    GetHashKey('COMPONENT_COMBATMG_CLIP_01'),
    GetHashKey('COMPONENT_COMBATMG_CLIP_02'),
    GetHashKey('COMPONENT_PUMPSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_SAWNOFFSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02'),
    GetHashKey('COMPONENT_PISTOL50_CLIP_01'),
    GetHashKey('COMPONENT_PISTOL50_CLIP_02'),
    GetHashKey('COMPONENT_ASSAULTSMG_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02'),
    GetHashKey('COMPONENT_AT_RAILCOVER_01'),
    GetHashKey('COMPONENT_AT_AR_AFGRIP'),
    GetHashKey('COMPONENT_AT_PI_FLSH'),
    GetHashKey('COMPONENT_AT_AR_FLSH'),
    GetHashKey('COMPONENT_AT_SCOPE_MACRO'),
    GetHashKey('COMPONENT_AT_SCOPE_SMALL'),
    GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'),
    GetHashKey('COMPONENT_AT_SCOPE_LARGE'),
    GetHashKey('COMPONENT_AT_SCOPE_MAX'),
    GetHashKey('COMPONENT_AT_PI_SUPP'),
}


weaponsHashNotInclude = {
	-1569615261,
	2725352035,
	-1768145561,
	-1075685676,
	1777342301,
	1895189586,
	-1326945657,
	883325847,
	-423489987,
	-1194089827,
	2031797409,
	-72657034,
	-1491061156,
	-722274890,
	1471386021,
	1875733908,
	-1951375401,
	1540159264,
	-196322845,
	2024373456,
	961495388,
	-1786099057,
	-86904375,
	-102973651
}