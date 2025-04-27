ESX = exports.es_extended:getSharedObject()
local testInProgress = false
local timerActive = false

-- Blip and NPC Creation
local blips = {
    {title = "Importu testavimas", colour = 5, id = 225, x = -534.2363, y = -166.5323, z = 38.3247},
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.8)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)

        RequestModel("s_m_y_xmech_02")
        while not HasModelLoaded("s_m_y_xmech_02") do
            Citizen.Wait(10)
        end
        local ped = CreatePed(4, GetHashKey("s_m_y_xmech_02"), info.x, info.y, info.z - 1, 25.00, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

-- Vehicle Cleanup
function vehicleDeductor()
    for veh in EnumerateVehicles() do
        DeleteEntity(veh)
    end
end

-- Timer Event
RegisterNetEvent('walker_timeris', function()
    if testInProgress then return end
    testInProgress = true
    timerActive = true

    SendNUIMessage({
        type = 'SHOW_TIMER',
        duration = Config.Laikas
    })

    -- Timer completion handler
    RegisterNUICallback('timerCompleted', function(data, cb)
        testInProgress = false
        timerActive = false
        DoScreenFadeOut(800)
        lib.hideTextUI()
        vehicleDeductor()
        Wait(2000)
        StartPlayerTeleport(PlayerId(), -534.5829, -165.8196, 38.3248, 204.8227, false, true, true)
        while IsPlayerTeleportActive() do
            Citizen.Wait(0)
        end
        DoScreenFadeIn(800)
        lib.showContext('walker_masinu_main')
        SendNUIMessage({type = 'HIDE_TIMER'})
        cb('ok')
    end)
end)

-- Vehicle Spawn
RegisterNetEvent('walker_spawnvehicele', function(args)
    if testInProgress then
        lib.notify({type = 'error', description = 'Jau testuojate transporto priemonę!'})
        return
    end

    local playerPed = PlayerPedId()
    local model = args.model

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(model, -526.6981, -150.6469, 38.1674, 345.7614, true, false)
    SetVehicleOnGroundProperly(vehicle)
    SetModelAsNoLongerNeeded(model)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    SetEntityVisible(playerPed, true)
    NetworkSetFriendlyFireOption(true)
    TriggerEvent('walker_timeris')
end)

-- Target Interaction
exports.ox_target:addSphereZone({
    coords = vec3(-534.2363, -166.5323, 38.3247),
    radius = 1,
    options = {
        {
            name = 'exit',
            icon = 'fa-solid fa-door-open',
            label = 'Importu testavimas',
            onSelect = function()
                lib.showContext('walker_masinu_main')
            end
        }
    }
})

-- Dynamic Menu Generation
local vehicleCategories = {
    { name = "Mercedes Benz", vehicles = Config.mercedes },
    { name = "BMW", vehicles = Config.bmw },
    { name = "Ferrari", vehicles = Config.ferrari },
    { name = "Lamborghini", vehicles = Config.lamborghini },
    { name = "Audi", vehicles = Config.audi },
    { name = "Aston Martin", vehicles = Config.astonmartin },
    { name = "Jeep", vehicles = Config.jeep },
    { name = "Nissan", vehicles = Config.nissan },
    { name = "Range Rover", vehicles = Config.rangerover },
    { name = "Rolls Royce", vehicles = Config.rollsroyce },
    { name = "Toyota", vehicles = Config.toyota },
    { name = "Ford", vehicles = Config.ford },
    { name = "Motociklai", vehicles = Config.motociklai }
}

local mainMenuOptions = {}

for i, category in ipairs(vehicleCategories) do
    local categoryMenuId = "category_menu_" .. i

    table.insert(mainMenuOptions, {
        title = category.name,
        description = 'Visi ' .. category.name .. ' automobiliai',
        menu = categoryMenuId,
        icon = 'car',
        iconAnimation = 'beatFade'
    })

    local categoryOptions = {}
    for j, veh in ipairs(category.vehicles) do
        table.insert(categoryOptions, {
            title = veh.pav,
            icon = 'fa-solid fa-car',
            iconAnimation = 'beatFade',
            event = 'walker_spawnvehicele',
            args = { model = GetHashKey(veh.spawn) }
        })
    end

    lib.registerContext({
        id = categoryMenuId,
        title = category.name,
        menu = 'walker_masinu_main',
        onBack = function() end,
        options = categoryOptions
    })
end

lib.registerContext({
    id = 'walker_masinu_main',
    title = 'Importu Testavimas',
    options = mainMenuOptions
})

-- Emergency Timer Cancel
RegisterCommand("canceltimer", function()
    if testInProgress then
        testInProgress = false
        timerActive = false
        SendNUIMessage({type = 'HIDE_TIMER'})
        vehicleDeductor()
        lib.notify({type = 'inform', description = 'Testavimas nutrauktas'})
    end
end)

-- Debug Commands
RegisterCommand("removestucktextui", function()
    lib.hideTextUI()
    SendNUIMessage({type = 'HIDE_TIMER'})
end)

RegisterCommand("walkeris", function()
    lib.showContext('walker_secret_menu')
end)

lib.registerContext({
    id = 'walker_secret_menu',
    title = 'KA??!! pizda radai mano paslepta meniu',
    menu = 'walker_masinu_main',
    onBack = function()
        print('Sveikinu')
    end,
    options = {
        {
            icon = 'skull',
            iconAnimation = 'bounce',
            title = 'WALKER DID THAT :)'
        }
    }
})