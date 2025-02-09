ESX = exports.es_extended:getSharedObject()
local testuoja = false -- placeholder variable

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
        Wait(3000)
        local ped = CreatePed(4, GetHashKey("s_m_y_xmech_02"), info.x, info.y, info.z - 1, 25.00, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

function vehicleDeductor()
    for veh in EnumerateVehicles() do
        DeleteEntity(veh)
    end
end

RegisterNetEvent('walker_timeris', function()
    local playerPed = GetPlayerPed(-1)
    local time = Config.Laikas 
    while time ~= 0 do
        lib.showTextUI('Jum liko ' .. time .. 's')
        Wait(1000)
        time = time - 1
    end
    DoScreenFadeOut(800)
    lib.hideTextUI()
    vehicleDeductor()
    Wait(2000)
    StartPlayerTeleport(PlayerId(source), -534.5829, -165.8196, 38.3248, 204.8227, false, true, true)
    while IsPlayerTeleportActive() do
        Citizen.Wait(0)
    end
    DoScreenFadeIn(800)
    lib.showContext('walker_masinu_main')
end)

RegisterNetEvent('walker_spawnvehicele', function(args)
    local playerPed = GetPlayerPed(-1)
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
    SetEntityLocallyInvisible(playerPed)
    SetCanAttackFriendly(playerPed, true, false)
    NetworkSetFriendlyFireOption(true)
    TriggerEvent('walker_timeris')
end)

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

-- Secret menu registration (unchanged)
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

RegisterCommand("walkeris", function()
    lib.showContext('walker_secret_menu')
end)

RegisterCommand("removestucktextui", function()
    lib.hideTextUI()
end)

RegisterCommand("testvehicle", function()
    DoScreenFadeOut(800)
    Wait(2000)
    StartPlayerTeleport(PlayerId(source), -534.5829, -165.8196, 38.3248, 204.8227, true, false, false)
    while IsPlayerTeleportActive() do
        Citizen.Wait(0)
    end
    DoScreenFadeIn(800)
end)

---------------------------------------------------
-- DYNAMIC MENU GENERATION BASED ON THE CONFIG DATA
---------------------------------------------------

-- Build a helper table of vehicle categories using your config keys.
local vehicleCategories = {
    { name = "Mercedes Benz", vehicles = Config.mercedes },
    { name = "BMW", vehicles = Config.bmw },
    { name = "Ferrari", vehicles = Config.ferrari },
    { name = "Lamborghini", vehicles = Config.lamborghini }
}

local mainMenuOptions = {}

for i, category in ipairs(vehicleCategories) do
    local categoryMenuId = "category_menu_" .. i

    -- Add an option for this vehicle category in the main menu.
    table.insert(mainMenuOptions, {
        title = category.name,
        description = 'Visi ' .. category.name .. ' automobiliai',
        menu = categoryMenuId,
        icon = 'car',
        iconAnimation = 'beatFade'
    })

    -- Build submenu options for each vehicle in this category.
    local categoryOptions = {}
    for j, veh in ipairs(category.vehicles) do
        table.insert(categoryOptions, {
            title = veh.pav,
            icon = 'fa-solid fa-car',
            iconAnimation = 'beatFade',
            metadata = {
                { label = 'Greitis', value = veh.greitis },
                { label = 'Kaina', value = veh.kaina },
                { label = 'Stabdymas', value = veh.stab }
            },
            -- Optionally, add an image URL here or leave it as a default placeholder.
            image = 'https://via.placeholder.com/150',
            event = 'walker_spawnvehicele',
            args = { model = GetHashKey(veh.spawn) }
        })
    end

    -- Register each category submenu.
    lib.registerContext({
        id = categoryMenuId,
        title = category.name,
        menu = 'walker_masinu_main',
        onBack = function() print('Returning from ' .. category.name) end,
        options = categoryOptions
    })
end

-- Finally, register the main menu which lists all categories.
lib.registerContext({
    id = 'walker_masinu_main',
    title = 'Importu Testavimas',
    options = mainMenuOptions
})
