ESXs = {}
ESXc = {}
local ServerCallbacks = {}
local CurrentServerRequestId = 0
local ClientCallbacks = {}

ESXs.TriggerServerCallback = function(name, cb, ...) -- 4
	ServerCallbacks[CurrentServerRequestId] = cb

	TriggerServerEvent('fq:triggerServerCallback', name, CurrentServerRequestId, ...)

	if CurrentServerRequestId < 65535 then
		CurrentServerRequestId = CurrentServerRequestId + 1
	else
		CurrentServerRequestId = 0
	end
end

RegisterNetEvent('fq:serverCallback')
AddEventHandler('fq:serverCallback', function(requestId, ...)
	ServerCallbacks[requestId](...)
	ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('fq:getServerObject')
AddEventHandler('fq:getServerObject', function(cb)
	cb(ESXs)
end)

function getServerObject()
	return ESXs
end
exports('getServerObject', getServerObject)

RegisterNetEvent('fq:getClientObject')
AddEventHandler('fq:getClientObject', function(cb)
	cb(ESXc)
end)


ESXc.TriggerClientCallback = function(name, requestId, cb, ...) -- 6
	if ClientCallbacks[name] ~= nil then
		
		ClientCallbacks[name](cb, ...)
	else
		print('fq_tools: TriggerClientCallback => [' .. name .. '] does not exist')
	end
end

ESXc.RegisterClientCallback = function(name, cb) -- 2
	ClientCallbacks[name] = cb
end

RegisterNetEvent('fq:triggerClientCallback')
AddEventHandler('fq:triggerClientCallback', function(name, requestId, ...) -- 5
	ESXc.TriggerClientCallback(name, requestID, function(...)
		TriggerServerEvent('fq:ClientCallback', requestId, ...)
	end, ...)
end)
-- RegisterClientCallback('fq:getSome', function(source, cb) -- 1
--     local ped
--     local id

--     cb(ped, id)
-- end)

-- TriggerServerCallback('fq:getSome', function(ped, id)  -- 3
--     -- bla bla bla
-- end)


-- ESXc.RegisterClientCallback('getPlayerCoords', function(cb)
--     local coords = GetEntityCoords(GetPlayerPed())
--     local headi = GetEntityHeading(GetPlayerPed())
--     headi = math.floor(headi * 100) / 100
--     local user = {
--         pos = coords,
--         heading = headi
--     }
--     cb(user)
-- end)


-- local ESXs = nil
-- local ESXc = nil

-- TriggerEvent('fq:getServerObject', function(obj) ESXs = obj end)
-- TriggerEvent('fq:getClientObject', function(obj) ESXc = obj end)
