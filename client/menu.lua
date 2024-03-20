OpenMenu = false
kartingMainMenu = RageUI.CreateMenu("Karting", "Intéractions disponibles", nil, nil)
kartingMainMenu.Closed = function()
    OpenMenu = false
end

local PositionKarting = {
    {x = -162.66833496094, y = -2131.0268554688, z = 15.705013275146, h = 206.26524353027},
}


local KartingVehicle = {
    {label = "Karting de course", model = "veto2", price = 5000, spawn = vector4(-158.06126403809, -2137.3999023438, 16.705017089844, 227.81083679199)},
}


function MainKarting()
    if OpenMenu then
        OpenMenu = false
        RageUI.Visible(kartingMainMenu, false)
        return
    else
        OpenMenu = true
        RageUI.Visible(kartingMainMenu, true)
        CreateThread(function()
            while OpenMenu do
                Wait(1)
                RageUI.IsVisible(kartingMainMenu, function()
                    for k,v in pairs(Config.KartingVehicle) do 
                        RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                            onSelected = function()
                                TriggerServerEvent("Ramoune:PaidKarting", v, Config.PositionKarting[1])
                            end
                        })
                    end
                end)
            end
        end)
    end
end



RegisterNetEvent("Ramoune:SpawnKarting")
AddEventHandler("Ramoune:SpawnKarting", function(model, spawn)
    local model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do  
        Wait(1)
    end
    local karting = CreateVehicle(model, spawn.x, spawn.y, spawn.z, 0.0, true, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), karting, -1)
    Entity(karting).state.fuel = 100
    RageUI.CloseAll()
end)



CreateThread(function()
    for k,v in pairs(PositionKarting) do 
        local blipKarting = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blipKarting, 127)
        SetBlipScale(blipKarting, 0.8)
        SetBlipColour(blipKarting, 17)
        SetBlipAsShortRange(blipKarting, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Karting")
        EndTextCommandSetBlipName(blipKarting)
        local PedsModel = GetHashKey("a_m_m_business_01")
        RequestModel(PedsModel)
        while not HasModelLoaded(PedsModel) do
            Wait(1)
        end
        local pedKarting = CreatePed(4, PedsModel, v.x, v.y, v.z, v.h, false, true)
        FreezeEntityPosition(pedKarting, true)
        SetEntityInvincible(pedKarting, true)
        SetBlockingOfNonTemporaryEvents(pedKarting, true)
        TaskStartScenarioInPlace(pedKarting, "WORLD_HUMAN_CLIPBOARD", 0, false)
    end
    while true do
        timer = 750
        local playerCoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.PositionKarting) do
            local distance = #(playerCoords - vector3(v.x, v.y, v.z))
            if distance < Config.drawDistance then
                timer = 0
                if distance < Config.itrDistance then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à la location de karting")
                    if IsControlJustPressed(0, 51) then
                        MainKarting()
                    end
                end
            elseif distance > 5.0 and distance < 15.0 then
                timer = 750
            end
        end
        Wait(timer)
    end
end)