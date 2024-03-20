RegisterServerEvent("Ramoune:PaidKarting")
AddEventHandler("Ramoune:PaidKarting", function(v, PositionKarting)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerCoords = GetEntityCoords(GetPlayerPed(_source))
    local distance = #(playerCoords - vector3(PositionKarting.x, PositionKarting.y, PositionKarting.z))

    if distance < 10.0 then
        if xPlayer.getMoney() >= v.price then
            xPlayer.removeMoney(v.price)
            TriggerClientEvent("Ramoune:SpawnKarting", _source, v.model, v.spawn)
            xPlayer.showNotification("~g~Vous avez loué un karting pour " ..v.price.."$")
        else
            xPlayer.showNotification("~r~Vous n'avez pas assez d'argent pour louer un karting")
        end
    else
        DropPlayer(_source, "Tentative de triche détectée, si vous pensez que c'est une erreur, contactez le staff. discord.gg/syltarp")
        console.warning("Le joueur "..xPlayer.getName().." a été kick pour tentative de triche ! (Karting TriggerServerEvent)")
    end

end)
