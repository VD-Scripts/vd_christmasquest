vRP = Proxy.getInterface("vRP")

local Config = {
    InteractSound = true,
    -- SoundTime = 11000,
    SoundVolume = 0.8,
    BagId = 45,
    Ture = 5,
    Marker = 0
}
-- Coordonate PED, Heading PED, Coordonate Jucator, Heading PED
local lColinde = {
    {-1024.3192138672,-1139.9490966797,2.7453277111053, 25.45550155, -1026.4191894531,-1136.5532226562,2.1704149246216, 210.60430},
    {-884.18444824219,-1072.5407714844,2.5316572189331, 35.5356, -885.6513671875,-1070.4265136719,2.162876367569, 212.24198},
    {-873.24652099609,562.845703125,96.619491577148, 129.809341, -874.72650146484,561.58697509766,96.619186401367, 309.49841},
    {-947.8662109375,567.76013183594,101.5072555542, 343.70361, -947.41577148438,569.45306396484,101.41568756104, 167.4016876},
    {-1277.9791259766,497.07675170898,97.890396118164, 277.101501, -1275.8046875,497.22637939453,97.888771057129, 92.262664},
    {-1413.4365234375,462.52069091797,109.20854949951, 46.398101, -1415.3745117188,464.27651977539,109.64903259277, 223.756637},
    {-1515.4635009766,24.27739906311,56.820713043213, 342.582214355, -1515.3115234375,25.827404022217,56.820636749268, 169.228820},
    {-1570.6915283203,23.662128448486,59.553806304932, 346.5522766, -1570.2517089844,25.155046463013,59.553817749023, 168.394134},
    {-1464.5404052734,-33.881370544434,55.050453186035, 310.11312866211, -1463.3410644531,-32.700847625732,54.702716827393, 133.255508},
    {-930.166015625,19.189262390137,48.325733184814, 212.53054, -929.21020507812,17.859350204468,47.829254150391, 37.178058},
    {-888.24761962891,42.565326690674,49.146987915039, 239.084106, -886.61560058594,41.429084777832,48.759307861328, 50.566364}
}
-- local Ped = {
--     {176.78118896484,-974.87286376953,30.093370437622, "a_m_y_motox_02", 153.661575} -- x, y, z, model, heading
-- }
local Muzici = { -- Numele piesei, Durata piesei
    {"marutmargaritar", 11000},
    {"scoalascoalagazdabuna", 8000},
    {"steauasusrasare", 11000}
}
local inPos,isInQuest,x,y,z,inColinda,zahar,theCp,triedOnce,PedSpawned,cooldown,cooldowns,mosGragiunMarker,cBlip,changeVal = false,false,0,0,0,false,false,0,false,nil,0,0,nil,nil,false
-- Threads
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if not inPos then
            if #(vector3(196.48634338379,-994.57189941406,30.091764450073) - GetEntityCoords(PlayerPedId())) <= 5 then
                exports.vd_info:Show("F", "APASA TASTA [F] PENTRU A INCEPE QUEST-UL", "#ff000063")
                inPos = true
            end
        else
            if #(vector3(196.48634338379,-994.57189941406,30.091764450073) - GetEntityCoords(PlayerPedId())) > 5 then
                inPos = false
                exports.vd_info:Hide("APASA TASTA [F] PENTRU A INCEPE QUEST-UL")
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        while inPos do
            Citizen.Wait(1)
            if not isInQuest then
                if IsControlJustPressed(0, 23) then
                    if GetPedDrawableVariation(PlayerPedId(),5) == Config.BagId and GetPedTextureVariation(PlayerPedId(),5) == 0 then
                        if cooldown == 0 then
                            isInQuest = true
                            local cp = math.random(1,1) -- 11
                            for k,v in pairs(lColinde) do
                                if k == cp then
                                    SetNewWaypoint(v[1],v[2])
                                    local name = GetStreetNameAtCoord(v[1],v[2],v[3])
                                    local sName = GetStreetNameFromHashKey(name)
                                    vRP.notify({ "[Christmas] Ai inceput quest-ul. Destinatie: "..sName.."!" })
                                    x,y,z = v[1], v[2], v[3]

                                    mosGragiunMarker = vRP.addMarkerSign({Config.Marker,v[1],v[2],v[3]-0.8,1,1,1,255, 255, 255,150,150,0,true,0})
                                    cBlip = vRP.addBlip({v[1],v[2],v[3],682,1,"Locatie de colindat"})
                                end
                            end
                        else
                            vRP.notify({ "Ai cooldown ("..cooldown.."m:"..cooldowns.."s)" })
                        end
                    else
                        vRP.notify({ "Nu ai geanta cu numarul "..Config.BagId.." pe tine!" })
                    end
                end
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isInQuest then
           if not inColinda then
                if x ~= nil and y ~= nil and z ~= nil then
                    if #(vector3(x,y,z) - GetEntityCoords(PlayerPedId())) <= 5 then
                        while true do
                            Citizen.Wait(1)
                            TriggerServerEvent("vD:verificaLocul")
                            if zahar then
                                vRP.notify({ "Cineva deja colinda aceasta casa. Asteapta..." })
                                SendNUIMessage({action="opresteText"})
                                break
                            end
                            exports.vd_info:Show("F", "APASA TASTA [F] PENTRU A COLINDA!", "#ff000063")
                            if IsControlJustPressed(0, 23) and not zahar then
                                exports.vd_info:Hide("APASA TASTA [F] PENTRU A COLINDA!")
                                TriggerServerEvent("vD:ocupaLocul", "add", x,y,z)
                                vRP.executeCommand({"e knock"})
                                Citizen.Wait(2000)

                                vRP.removeMarkerSign({mosGragiunMarker})
                                vRP.removeBlip({cBlip})

                                RequestModel(GetHashKey("a_m_m_og_boss_01"))
                                while not HasModelLoaded(GetHashKey("a_m_m_og_boss_01")) do
                                    Citizen.Wait(1)
                                end
                                for k,v in pairs(lColinde) do
                                    if x == v[1] then
                                        PedSpawned =  CreatePed(4, "a_m_m_og_boss_01", v[1],v[2],v[3]-1, v[4], false, true)
                                        vRP.teleport({v[5],v[6],v[7]-1})
                                        SetEntityHeading(PlayerPedId(),v[8])
                                    end
                                end

                                inColinda = true
                                local timp
                                exports.vd_info:Hide()
                                FreezeEntityPosition(PlayerPedId(),true)
                                if Config.InteractSound then
                                    local m = math.random(1,3)
                                    for k,v in pairs(Muzici) do
                                        if k == m then
                                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, v[1], Config.SoundVolume)
                                            timp = v[2]
                                        end
                                    end
                                end
                                vRP.executeCommand({"e guitar"})

                                exports.VD_progressbar:Start("Colinzi", timp) -- Wait included

                                inColinda = false
                                zahar = false
                                triedOnce = false
                                TriggerServerEvent("vD:ocupaLocul", "remove")
                                theCp = theCp+1 
                                FreezeEntityPosition(PlayerPedId(),false)
                                vRP.executeCommand({"e c"})
                                DeleteEntity(PedSpawned)
                                break
                            end
                        end
                    end
                end
           end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if cooldown > 0 then
            cooldowns = cooldowns - 1
            if cooldowns <= 0 then
                cooldown = cooldown - 1
                cooldowns = 60
            end
        end
    end
end)
-- Threads

-- Events
RegisterNetEvent("vD:dariusmen1", function(p) -- AICI DESCHIDE
    SendNUIMessage({type="open",portocale=p})
    SetNuiFocus(true,true)
end)
RegisterNetEvent("vD:cancel", function(val)
    if val == "not" then
        zahar = false
        return
    elseif val == "yes" then
        zahar = true
    end
end)
RegisterNetEvent("vD:nextCheckpoint", function()
    if theCp == Config.Ture then
        theCp = 0
        isInQuest = false
        cooldown = 30
        vRP.notify({ "Ai terminat quest-ul" })
        x,y,z = nil,nil,nil
        return
    end 
    if isInQuest then
        local cp = math.random(1,11)
        for k,v in pairs(lColinde) do
            if k == cp then
                SetNewWaypoint(v[1],v[2])
                local name = GetStreetNameAtCoord(v[1],v[2],v[3])
                local sName = GetStreetNameFromHashKey(name)
                vRP.notify({ "[Christmas] Continua tot asa! Destinatie: "..sName.."!" })
                x,y,z = v[1], v[2], v[3]

                mosGragiunMarker = vRP.addMarkerSign({Config.Marker,v[1],v[2],v[3]-0.8,1,1,1,255, 255, 255,150,150,0,true,0})
                cBlip = vRP.addBlip({v[1],v[2],v[3],682,1,"Locatie de colindat"})
            end
        end
    end
end)
RegisterNUICallback("inchide", function()
    SetNuiFocus(false,false)
    vRP.notify({"Ai inchis meniul"})
end)
RegisterNUICallback("buy", function(data)
    TriggerServerEvent("vD:santaClaus", data)
end)
-- Events
-- Ped
-- Citizen.CreateThread(function()
--     for k,v in pairs(Ped) do
--         RequestModel(GetHashKey(v[4]))
--         while not HasModelLoaded(GetHashKey(v[4])) do
--             Citizen.Wait(1)
--         end
--         ped =  CreatePed(4, v[4],v[1],v[2],v[3]-1, v[5], false, true)
--         SetEntityHeading(ped, v[5])
--         FreezeEntityPosition(ped, true)
--         SetEntityInvincible(ped, true)
--         SetBlockingOfNonTemporaryEvents(ped, true)
--     end
-- end)