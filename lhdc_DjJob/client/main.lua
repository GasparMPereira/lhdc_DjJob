--Gaspar Pereira - gaspar#0880--
local Keys = {
  ["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18, ["SPACE"] = 22, ["DELETE"] = 178
}
local PlayerData = {}
local menuIsShowed = false
local hintIsShowed = false
local hasAlreadyEnteredMarker = false
local Blips = {}
local JobBlips = {}
local blip_dj = 0
local isInMarker = false
local isInPublicMarker = false
local hintToDisplay = "no hint to display"
local onDuty = false
local spawner = 0
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(2000)
	  if ESX.PlayerData.job.name == 'clubdj' then
		havingDjJob = true
		if blip_dj == nil or blip_dj == 0 then
		  blip_dj = AddBlipForCoord(-1381.09, -616.22, 30.5)
		  SetBlipSprite(blip_dj, 614)
		  SetBlipDisplay(blip_dj, 4)
		  SetBlipScale(blip_dj, 0.8)
		  SetBlipColour(blip_dj, 48)
		  SetBlipAsShortRange(blip_dj, true)
		  BeginTextCommandSetBlipName("STRING")
		  AddTextComponentString(_U('dj_blip'))
		  EndTextCommandSetBlipName(blip_dj)
		end
	  else
		havingDjJob = false
		if blip_dj ~= 0 then
		  RemoveBlip(blip_dj)
		  blip_dj = 0
		end
	  end
	end
  end)
function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'clubdj' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end
function OpenMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		elements = {
			{label = _U('start_work'), value = 'start_work'},
			{label = _U('stop_work'), value = 'stop_work'}
		}
	}, function(data, menu)
		if data.current.value == 'stop_work' then
			onDuty = false
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'start_work' then
			onDuty = true
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler('esx_clubdj:action', function(job, zone)
	menuIsShowed = true
	if zone.Type == "cloakroom" then
		OpenMenu()
	elseif zone.Type == "work" then
		hintToDisplay = "no hint to display"
		hintIsShowed = false
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			ESX.ShowNotification(_U('foot_work'))
		else
			TriggerServerEvent('esx_clubdj:startWork', zone.Item)
		end
	elseif zone.Type == "troca_tips" then
		hintToDisplay = "no hint to display"
		hintIsShowed = false
		TriggerServerEvent('esx_clubdj:startWork', zone.Item)
	end
end)

AddEventHandler('esx_clubdj:hasExitedMarker', function(zone)
	TriggerServerEvent('esx_clubdj:stopWork')
	hintToDisplay = "no hint to display"
	menuIsShowed = false
	hintIsShowed = false
	isInMarker = false
end)

-- Show top left hint
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if hintIsShowed then
			ESX.ShowHelpNotification(hintToDisplay)
		else
			Citizen.Wait(50)
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local zones = {}
		local coords = GetEntityCoords(PlayerPedId())
		if IsJobTrue() then
			for k,v in pairs(Config.Jobs) do
				if ESX.PlayerData.job.name == k then
					zones = v.Zones
				end
			end
			for k,v in pairs(zones) do
				if onDuty or v.Type == "cloakroom" or ESX.PlayerData.job.name == "reporter" then
					if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					end
				end
			end
		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsJobTrue() then
			local zones = nil
			local job = nil
			for k,v in pairs(Config.Jobs) do
				if ESX.PlayerData.job.name == k then
					job = v
					zones = v.Zones
				end
			end
			if zones ~= nil then
				local coords      = GetEntityCoords(PlayerPedId())
				local currentZone = nil
				local zone        = nil
				local lastZone    = nil
				for k,v in pairs(zones) do
					if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
						isInMarker = true
						currentZone = k
						zone = v
						break
					else
						isInMarker  = false
					end
				end
				if IsControlJustReleased(0, Keys['E']) and not menuIsShowed and isInMarker then
					if onDuty or zone.Type == "cloakroom" then
						TriggerEvent('esx_clubdj:action', job, zone)
					end
				end
				-- hide or show top left zone hints
				if isInMarker and not menuIsShowed then
					hintIsShowed = true
					if (onDuty or zone.Type == "cloakroom") then
						hintToDisplay = zone.Hint
						hintIsShowed = true
					elseif onDuty and zone.Type == "troca_tips" then
						hintToDisplay = _U('dj_cash_tips')
						hintIsShowed = true
					elseif not isInPublicMarker then
						hintToDisplay = "no hint to display"
						hintIsShowed = false
					end
				end
			end
			if isInMarker and not hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = true
			end
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_clubdj:hasExitedMarker', zone)
			end
		end
	end
end)

-- Peds, Música desativa, load e delete de peds
CreateThread(function()
	while true do
		Wait(1000)
		if IsAmbientZoneEnabled("az_dlc_heists_bahama_mamas") then
			SetAmbientZoneStatePersistent("az_dlc_heists_bahama_mamas", false, false)
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		if (Config.UsePeds == true) then
			if GetInteriorFromEntity(PlayerPedId()) == GetInteriorAtCoords(-1390.2, -607.5, 30.3) then
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 37, true)
				DisableControlAction(0, 140, true)
				if not DoesEntityExist(Config.InsidePeds["Bar1"][1]) then
					LoadBahamas()
				end
			else
				if DoesEntityExist(Config.InsidePeds["Bar1"][1]) then
					LeaveBahamas()
				end
			end
		end
	end
end)
function RequestEntModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end
	SetModelAsNoLongerNeeded(model)
end
function PlayAnim(ped, animDict, animName)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do 
		Wait(0) 
	end
	TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, -1, 1, 1, false, false, false)
	RemoveAnimDict(animDict)
end
function RequestTexture(texture)
	RequestStreamedTextureDict(texture)
	while not HasStreamedTextureDictLoaded(texture) do 
		Wait(0) 
	end
	SetStreamedTextureDictAsNoLongerNeeded(texture)
end
function DrawMyNotification(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end
function ShowClubNotification(msg)
	RequestTexture("char_bahamamamas")
	DrawMyNotification('Bahama Mamas', '', msg, "char_bahamamamas", 1)
end
function CreatePeds()
	for k, v in pairs(Config.InsidePeds) do
		if not v[1] then
			RequestEntModel(v[3])
			v[1] = CreatePed(v[2], v[3], v[4], false, true)
			if v[5] ~= nil then
				TaskStartScenarioAtPosition(v[1], v[5], v[4], -1, false, true)
			end
			SetModelAsNoLongerNeeded(v[2])
		end
		for q, t in pairs(Config.PedComponents) do
			if q == k then
				t[1] = v[1]
			end
		end
		for i, o in pairs(Config.PedAnims) do
			if i == k then
				o[1] = v[1]
			end
		end
		if k == "Bar3" or string.match(k, "sitting") then
			FreezeEntityPosition(v[1], true)
		end
		SetPedAsEnemy(v[1], false)
		SetBlockingOfNonTemporaryEvents(v[1], true)
		SetPedResetFlag(v[1], 249, true)
		SetPedConfigFlag(v[1], 185, true)
		SetPedConfigFlag(v[1], 108, true)
		SetPedConfigFlag(v[1], 106, true)
		SetPedCanEvasiveDive(v[1], false)
		N_0x2f3c3d9f50681de4(v[1], 1)
		SetPedCanRagdollFromPlayerImpact(v[1], false)
		SetPedCanRagdoll(v[1], false)
		SetPedConfigFlag(v[1], 208, true)
		SetEntityInvincible(v[1], true)
	end
	for k, v in pairs(Config.PedComponents) do
		SetPedComponentVariation(v[1], v[2], v[3], v[4], v[5])
	end
	for k, v in pairs(Config.PedAnims) do
		PlayAnim(v[1], v[2], v[3])
	end
end
function DeletePeds()
	for k, v in pairs(Config.InsidePeds) do
		if DoesEntityExist(v[1]) then
			DeleteEntity(v[1])
			v[1] = false
		end
	end
end
function LoadBahamas()
	CreatePeds()
	if IsPedArmed(PlayerPedId(), 7) then
		SetCurrentPedWeapon(PlayerPedId(), "WEAPON_UNARMED" ,true)
	end
	ShowClubNotification("We don't tolerate any violence around here. We will be holding onto your weapons until you leave.")
	Wait(1000)
	for k,v in pairs(Config.InsidePeds) do
		FreezeEntityPosition(v[1], true)
	end
end
function LeaveBahamas()
	DeletePeds()
	EnableAllControlActions(0)
end
