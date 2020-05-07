ESXs = {}
ESXc = {}
local ServerCallbacks = {}
local ClientCallbacks = {}
local CurrentClientRequestId = 0

ESXs.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ServerCallbacks[name] ~= nil then
		ServerCallbacks[name](source, cb, ...)
		
	else
		print('fq_tools: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

ESXs.RegisterServerCallback = function(name, cb) -- 2
	ServerCallbacks[name] = cb
end

RegisterServerEvent('fq:triggerServerCallback')
AddEventHandler('fq:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	ESXs.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('fq:serverCallback', _source, requestId, ...)
	end, ...)
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


ESXc.TriggerClientCallback = function(name, cb, source, ...) -- 4 add source here
	ClientCallbacks[CurrentClientRequestId] = cb
	TriggerClientEvent('fq:triggerClientCallback', source, name, CurrentClientRequestId, ...)
	
	if CurrentClientRequestId < 65535 then
		CurrentClientRequestId = CurrentClientRequestId + 1
	else
		CurrentClientRequestId = 0
	end
end

RegisterNetEvent('fq:ClientCallback') -- 7
AddEventHandler('fq:ClientCallback', function(requestId, ...)
	ClientCallbacks[requestId](...)
	ClientCallbacks[requestId] = nil
end)
-- TriggerClientCallback('fq:getSome', function(ped, id)  -- 3
--     -- bla bla bla
-- end)

-- RegisterServerCallback('fq:getSome', function(source, cb) -- 1
--     local ped
--     local id

--     cb(ped, id)
-- end)

-- ESXs.RegisterServerCallback('getInfoEvn', function(source, cb)
--     local kek = 10
--     local kek2 = 20
--     cb(10, 20)
-- end)

-- local ESXs = nil
-- local ESXc = nil

-- TriggerEvent('fq:getServerObject', function(obj) ESXs = obj end)
-- TriggerEvent('fq:getClientObject', function(obj) ESXc = obj end)
