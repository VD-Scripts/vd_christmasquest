local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "VDScripts_portocale")
local players = {}
RegisterCommand("christmas", function(source)
    local user_id = vRP.getUserId({source})
    TriggerClientEvent("vD:dariusmen1", source, vRP.getInventoryItemAmount({user_id,"oranges",}))
end)
RegisterServerEvent("vD:ocupaLocul", function(c,x,y,z)
    source = source
    local user_id = vRP.getUserId({source})
    if c == "add" then 
        table.insert(players, {id=user_id,x=x,y=y,z=z})
    elseif c == "remove" then
        local p = math.random(5,15)
        -- exports.oxmysql:query("UPDATE vrp_users SET oranges=oranges + @p WHERE id=@playerId", {p = p, playerId = user_id})
        vRP.giveInventoryItem({user_id, "oranges", p, false})
        vRPclient.notify(source, { "Colindatului ia placut colinda ta asa ca ti-a oferit "..p.." portocale" })
        for k,v in pairs(players) do
            if v.id == user_id then
                table.remove(players, k)
                TriggerClientEvent("vD:cancel", source, "not")
            end
        end
        TriggerClientEvent("vD:nextCheckpoint", source)
    end
end)
RegisterServerEvent("vD:verificaLocul", function(once)
    source = source
    local user_id = vRP.getUserId({source})
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    if #players > 0 then
        for k,v in pairs(players) do
            if #(GetEntityCoords(ped) - vector3(v.x,v.y,v.z)) <= 5 then            
                if #players > 0 then
                    if v.id ~= user_id then
                        TriggerClientEvent("vD:cancel", source, "yes")
                    else
                        TriggerClientEvent("vD:cancel", source, "not")
                    end
                end
            end
        end
    else
        TriggerClientEvent("vD:cancel", source, "not")
    end
end)
RegisterServerEvent("vD:santaClaus", function(data)
    if data.men then
        source = source
        local user_id = vRP.getUserId{source}
        -- exports.oxmysql:query("SELECT oranges FROM vrp_users WHERE id = @playerId AND oranges >= @org", {playerId = user_id, org = data.men}, function(rows)
        --     source = vRP.getUserSource({user_id})
        --     if #rows > 0 then
        --         vRP.giveMoney({user_id,data.val})
        --         exports.oxmysql:query("UPDATE vrp_users SET oranges = @oranges WHERE id = @playerId", {oranges = rows[1].oranges - data.men, playerId = user_id})
        --         vRPclient.notify(source,{"Ai vandut ".. data.men .." portocale si ai primit ".. data.val .."$"})
        --     else
        --         vRPclient.notify(source,{"Nu ai bordogale."})
        --     end
        -- end)
        if vRP.tryGetInventoryItem({user_id,"oranges",data.men,false}) then
            vRP.giveMoney({user_id,data.val})
            vRPclient.notify(source,{"Ai vandut ".. data.men .." portocale si ai primit ".. data.val .."$"})
        else
            vRPclient.notify(source,{"Nu ai bordogale."})
        end
    end
end)