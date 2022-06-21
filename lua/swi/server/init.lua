Swi.Server = {}
Swi.Server.__index = Swi.Server

Swi.Server.playersSets = {}

util.AddNetworkString("Swi_GiveDefaultSet")
util.AddNetworkString("Swi_CleanupAllWeapons")
util.AddNetworkString("Swi_CleanupActiveWeapon")
util.AddNetworkString("Swi_CleanupAllAmmo")

net.Receive("Swi_CleanupAllWeapons", function(_, player)
    player:StripWeapons()
end)

net.Receive("Swi_CleanupActiveWeapon", function(_, player)
    player:StripWeapon(player:GetActiveWeapon():GetClass())
end)

net.Receive("Swi_CleanupAllAmmo", function(_, player)
    player:StripAmmo()
end)

net.Receive("Swi_GiveDefaultSet", function(_, player) 
    Swi.defaultSet:give(player)
end)

hook.Add("PlayerSpawn", "Swi_GiveSpawnSet", function(player) 
    if player:IsBot() or 
       not GetConVar("swi_sv_save_weapons"):GetBool() or 
       player:GetInfo("swi_save_weapons") == "0" then 
        return
    end

    local playerSets = Swi.Server.playersSets[player:SteamID()]
    
    if playerSets then
        local set = playerSets[playerSets._selected] or playerSets._spawn

        if not set then return end

        timer.Simple(0, function() 
            set:give(
                player, 
                player:GetInfo("swi_select_weapon") == "1", 
                true, 
                true,
                player:GetInfo("swi_base_ammo") == "0"
            ) 
        end)
    else
        Swi.Server.playersSets[player:SteamID()] = {
            _selected = "_spawn"
        }
    end
end)

hook.Add("PlayerDisconnected", "Swi_RemovePlayerSets", function(player) 
    local steamId = player:SteamID()
    
    if Swi.Server.playersSets[steamId] then
        Swi.Server.playersSets[steamId] = nil
    end
end)

hook.Add("DoPlayerDeath", "Swi_CreateSpawnSet", function(player)
    local spawnSet = Swi.createSet(player)
    local activeWeapon = player:GetActiveWeapon()
    local steamId = player:SteamID()

    if IsValid(activeWeapon) then
        spawnSet.selectedWeapon = activeWeapon:GetClass()
    end

    local playerSets = Swi.Server.playersSets[steamId]

    if playerSets then
        playerSets._spawn = spawnSet
    else
        Swi.Server.playersSets[steamId] = {
            _spawn = spawnSet,
            _selected = "_spawn"
        }
    end
end)