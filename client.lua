ESX = exports.es_extended:getSharedObject()
local testuoja = false -- bbz kodel bet tegu buna vistiek jis nieko nedaro

local blips = {
     {title="Importu testavimas", colour=5, id=225, x = -534.2363, y = -166.5323, z = 38.3247},
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
      local ped = CreatePed(4, GetHashKey("s_m_y_xmech_02"), -534.2363, -166.5323, 38.3247 - 1, 25.00, false, true)
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
  local PedVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  local time = Config.Laikas 
  while (time ~= 0) do
    lib.showTextUI('Jum liko ' ..time.. 's')
      Wait( 1000 )
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
		
local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0, 5.0, 0)
local vehicle = CreateVehicle(model, -526.6981, -150.6469, 38.1674, 345.7614, true, false)
SetVehicleOnGroundProperly(vehicle)
SetModelAsNoLongerNeeded(model)
TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
SetEntityVisible(GetPlayerPed(-1), true)
SetEntityLocallyInvisible(GetPlayerPed(-1))
SetCanAttackFriendly(GetPlayerPed(-1), true, false)
NetworkSetFriendlyFireOption(true)
TriggerEvent('walker_timeris')
--timeris()
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

---------- Visi lib context
lib.registerContext({
  id = 'walker_masinu_main',
  title = 'Importu Testavimas',
  options = {
{
  title = 'Mercedes Benz',
  description = 'Visi Mercedes Benz automobiliai',
  menu = 'masinu_testavimo_benz',
  icon = 'car',
  iconAnimation = 'beatFade',
},
{
  title = 'BMW',
  description = 'Visi BMW automobiliai',
  menu = 'masinu_testavimo_bmw',
  icon = 'car',
  iconAnimation = 'beatFade',
},
{
  title = 'Ferrari',
  description = 'Visi Ferrari automobiliai',
  menu = 'masinu_testavimo_ferrari',
  icon = 'car',
  iconAnimation = 'beatFade',
},
{
  title = 'Lamborghini',
  description = 'Visi Lamborghini automobiliai',
  menu = 'masinu_testavimo_lamborghini',
  icon = 'car',
  iconAnimation = 'beatFade',
},
            }
})


lib.registerContext({
  id = 'masinu_testavimo_benz',
  title = 'Mercedes Benz',
  menu = 'walker_masinu_main',
  onBack = function()
    print('Sveikinu')
  end,
  options = {
    {
      title = Config.mercedes[1].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.mercedes[1].greitis},
        {label = 'Kaina', value = Config.mercedes[1].kaina},
        {label = 'Stabdymas', value = Config.mercedes[1].stab}
      },
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8SMmwiNlvxAIB4Sn0K3N4Ql7enK0XHhR0QK3OsqA2YQ&s',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.mercedes[1].spawn)
      },
    },
    {
      title = Config.mercedes[2].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.mercedes[2].greitis},
        {label = 'Kaina', value = Config.mercedes[2].kaina},
        {label = 'Stabdymas', value = Config.mercedes[2].stab}
      },
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdmU-oURAQay8gkFKsG9jAlaNMHkL8N4olDIa4naFFkg&s',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.mercedes[2].spawn)
      },
    },
    {
      title = Config.mercedes[3].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.mercedes[3].greitis},
        {label = 'Kaina', value = Config.mercedes[3].kaina},
        {label = 'Stabdymas', value = Config.mercedes[3].stab}
      },
      image = 'https://staticg.sportskeeda.com/editor/2022/08/b9112-16596050804482.png?w=640',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.mercedes[3].spawn)
      },
    },
    {
      title = Config.mercedes[4].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.mercedes[4].greitis},
        {label = 'Kaina', value = Config.mercedes[4].kaina},
        {label = 'Stabdymas', value = Config.mercedes[4].stab}
      },
      image = 'https://lh6.googleusercontent.com/proxy/TxAYxR3eb4AAVXStKgDrO08v3-dlzOUVjm3KrT5Z8sT5lCG7oncyaspM19V2woGxgk2b2UPN_nPnDlSNIYl0EHkc686DX6GcV6W8nkkIw7K0L40',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.mercedes[4].spawn)
      },
    },
    {
      title = Config.mercedes[5].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.mercedes[5].greitis},
        {label = 'Kaina', value = Config.mercedes[5].kaina},
        {label = 'Stabdymas', value = Config.mercedes[5].stab}
      },
      image = 'https://lh6.googleusercontent.com/proxy/TxAYxR3eb4AAVXStKgDrO08v3-dlzOUVjm3KrT5Z8sT5lCG7oncyaspM19V2woGxgk2b2UPN_nPnDlSNIYl0EHkc686DX6GcV6W8nkkIw7K0L40',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.mercedes[5].spawn)
      },
    }
  }
})

lib.registerContext({
  id = 'masinu_testavimo_bmw',
  title = 'BMW',
  menu = 'walker_masinu_main',
  onBack = function()
    print('Sveikinu')
  end,
  options = {
    {
      title = Config.bmw[1].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.bmw[1].greitis},
        {label = 'Kaina', value = Config.bmw[1].kaina},
        {label = 'Stabdymas', value = Config.bmw[1].stab}
      },
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8SMmwiNlvxAIB4Sn0K3N4Ql7enK0XHhR0QK3OsqA2YQ&s',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.bmw[1].spawn)
      },
    },
    {
      title = Config.bmw[2].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.bmw[2].greitis},
        {label = 'Kaina', value = Config.bmw[2].kaina},
        {label = 'Stabdymas', value = Config.bmw[2].stab}
      },
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdmU-oURAQay8gkFKsG9jAlaNMHkL8N4olDIa4naFFkg&s',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.bmw[2].spawn)
      },
    },
    {
      title = Config.bmw[3].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.bmw[3].greitis},
        {label = 'Kaina', value = Config.bmw[3].kaina},
        {label = 'Stabdymas', value = Config.bmw[3].stab}
      },
      image = 'https://staticg.sportskeeda.com/editor/2022/08/b9112-16596050804482.png?w=640',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.bmw[3].spawn)
      },
    },
    {
      title = Config.bmw[4].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.bmw[4].greitis},
        {label = 'Kaina', value = Config.bmw[4].kaina},
        {label = 'Stabdymas', value = Config.bmw[4].stab}
      },
      image = 'https://lh6.googleusercontent.com/proxy/TxAYxR3eb4AAVXStKgDrO08v3-dlzOUVjm3KrT5Z8sT5lCG7oncyaspM19V2woGxgk2b2UPN_nPnDlSNIYl0EHkc686DX6GcV6W8nkkIw7K0L40',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.bmw[4].spawn)
      },
    },
    {
      title = Config.bmw[5].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.bmw[5].greitis},
        {label = 'Kaina', value = Config.bmw[5].kaina},
        {label = 'Stabdymas', value = Config.bmw[5].stab}
      },
      image = 'https://lh6.googleusercontent.com/proxy/TxAYxR3eb4AAVXStKgDrO08v3-dlzOUVjm3KrT5Z8sT5lCG7oncyaspM19V2woGxgk2b2UPN_nPnDlSNIYl0EHkc686DX6GcV6W8nkkIw7K0L40',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.bmw[5].spawn)
      },
    }
  }
})

lib.registerContext({
  id = 'masinu_testavimo_ferrari',
  title = 'Ferrari',
  menu = 'walker_masinu_main',
  onBack = function()
    print('Sveikinu')
  end,
  options = {
    {
      title = Config.ferrari[1].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.ferrari[1].greitis},
        {label = 'Kaina', value = Config.ferrari[1].kaina},
        {label = 'Stabdymas', value = Config.ferrari[1].stab}
      },
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8SMmwiNlvxAIB4Sn0K3N4Ql7enK0XHhR0QK3OsqA2YQ&s',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.ferrari[1].spawn)
      },
    },
    {
      title = Config.ferrari[2].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.ferrari[2].greitis},
        {label = 'Kaina', value = Config.ferrari[2].kaina},
        {label = 'Stabdymas', value = Config.ferrari[2].stab}
      },
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdmU-oURAQay8gkFKsG9jAlaNMHkL8N4olDIa4naFFkg&s',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.ferrari[2].spawn)
      },
    },
    {
      title = Config.ferrari[3].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.ferrari[3].greitis},
        {label = 'Kaina', value = Config.ferrari[3].kaina},
        {label = 'Stabdymas', value = Config.ferrari[3].stab}
      },
      image = 'https://staticg.sportskeeda.com/editor/2022/08/b9112-16596050804482.png?w=640',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.ferrari[3].spawn)
      },
    },
    {
      title = Config.ferrari[4].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.ferrari[4].greitis},
        {label = 'Kaina', value = Config.ferrari[4].kaina},
        {label = 'Stabdymas', value = Config.ferrari[4].stab}
      },
      image = 'https://lh6.googleusercontent.com/proxy/TxAYxR3eb4AAVXStKgDrO08v3-dlzOUVjm3KrT5Z8sT5lCG7oncyaspM19V2woGxgk2b2UPN_nPnDlSNIYl0EHkc686DX6GcV6W8nkkIw7K0L40',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.ferrari[4].spawn)
      },
    },
    {
      title = Config.ferrari[5].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.ferrari[5].greitis},
        {label = 'Kaina', value = Config.ferrari[5].kaina},
        {label = 'Stabdymas', value = Config.ferrari[5].stab}
      },
      image = 'https://lh6.googleusercontent.com/proxy/TxAYxR3eb4AAVXStKgDrO08v3-dlzOUVjm3KrT5Z8sT5lCG7oncyaspM19V2woGxgk2b2UPN_nPnDlSNIYl0EHkc686DX6GcV6W8nkkIw7K0L40',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.ferrari[5].spawn)
      },
    }
  }
})

lib.registerContext({
  id = 'masinu_testavimo_lamborghini',
  title = 'Lamborghini',
  menu = 'walker_masinu_main',
  onBack = function()
    print('Sveikinu')
  end,
  options = {
    {
      title = Config.lamborghini[1].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.lamborghini[1].greitis},
        {label = 'Kaina', value = Config.lamborghini[1].kaina},
        {label = 'Stabdymas', value = Config.lamborghini[1].stab}
      },
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8SMmwiNlvxAIB4Sn0K3N4Ql7enK0XHhR0QK3OsqA2YQ&s',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.lamborghini[1].spawn)
      },
    },
    {
      title = Config.lamborghini[2].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.lamborghini[2].greitis},
        {label = 'Kaina', value = Config.lamborghini[2].kaina},
        {label = 'Stabdymas', value = Config.lamborghini[2].stab}
      },
      image = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdmU-oURAQay8gkFKsG9jAlaNMHkL8N4olDIa4naFFkg&s',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.lamborghini[2].spawn)
      },
    },
    {
      title = Config.lamborghini[3].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.lamborghini[3].greitis},
        {label = 'Kaina', value = Config.lamborghini[3].kaina},
        {label = 'Stabdymas', value = Config.lamborghini[3].stab}
      },
      image = 'https://staticg.sportskeeda.com/editor/2022/08/b9112-16596050804482.png?w=640',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.lamborghini[3].spawn)
      },
    },
    {
      title = Config.lamborghini[4].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.lamborghini[4].greitis},
        {label = 'Kaina', value = Config.lamborghini[4].kaina},
        {label = 'Stabdymas', value = Config.lamborghini[4].stab}
      },
      image = 'https://lh6.googleusercontent.com/proxy/TxAYxR3eb4AAVXStKgDrO08v3-dlzOUVjm3KrT5Z8sT5lCG7oncyaspM19V2woGxgk2b2UPN_nPnDlSNIYl0EHkc686DX6GcV6W8nkkIw7K0L40',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.lamborghini[4].spawn)
      },
    },
    {
      title = Config.lamborghini[5].pav,
      icon = 'fa-solid fa-car',
      iconAnimation = 'beatFade',
      metadata = {
        {label = 'Greitis', value = Config.lamborghini[5].greitis},
        {label = 'Kaina', value = Config.lamborghini[5].kaina},
        {label = 'Stabdymas', value = Config.lamborghini[5].stab}
      },
      image = 'https://lh6.googleusercontent.com/proxy/TxAYxR3eb4AAVXStKgDrO08v3-dlzOUVjm3KrT5Z8sT5lCG7oncyaspM19V2woGxgk2b2UPN_nPnDlSNIYl0EHkc686DX6GcV6W8nkkIw7K0L40',
      event = 'walker_spawnvehicele',
      args = {
        model = GetHashKey(Config.lamborghini[5].spawn)
      },
    }
  }
})