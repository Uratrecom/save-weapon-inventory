util.AddNetworkString("GiveDefaultWeapons")
util.AddNetworkString("GiveDefaultWeaponsWithAmmo")
util.AddNetworkString("CleanupAllWeapons")
util.AddNetworkString("CleanupActiveWeapon")
util.AddNetworkString("CleanupAllAmmo")

net.Receive("CleanupAllWeapons", function(_, player)
    player:StripWeapons()
end)

net.Receive("CleanupActiveWeapon", function(_, player)
    player:StripWeapon(player:GetActiveWeapon():GetClass())
end)

net.Receive("CleanupAllAmmo", function(_, player)
    player:StripAmmo()
end)

net.Receive("GiveDefaultWeapons", function(_, player) 
    SWI.defaultSet:giveWeapons(player, false, true)
end)

net.Receive("GiveDefaultWeaponsWithAmmo", function(_, player) 
    SWI.defaultSet:give(player)
end)

local playersSets = {}

hook.Add("PlayerDisconnected", "RemoveSetsFromServer", function(player)
    if player:IsBot() then return end

    timer.Create(player:SteamID() .. " cleanup", 5*60, 1, function()
        playersSets[player:SteamID()] = nil
    end)
end)

hook.Add("PlayerSpawn", "GiveSpawnSet", function(player) 
    if timer.Exists(player:SteamID() .. " cleanup") then
        timer.Remove(player:SteamID() .. " cleanup")
    end

    if player:IsBot() or 
        not GetConVar("swi_admin_save_weapons"):GetBool() or 
        player:GetInfo("swi_save_weapons") == "0" then 
        return
    end

    local playerSets = playersSets[player:SteamID()]
    
    if playerSets then
        timer.Simple(0, function() 
            playerSets:find("spawn"):give(
                player, 
                player:GetInfo("swi_select_weapon"), 
                true, 
                true,
                player:GetInfo("swi_base_ammo")
            ) 
        end)
    else 
        playersSets[player:SteamID()] = SWI.Sets.init()
    end
end)

hook.Add("DoPlayerDeath", "CreateSpawnSet", function(player)
    if not IsValid(player) then return end

    local spawnSet = SWI.createSet(player, "spawn")

    if IsValid(player:GetActiveWeapon()) then
        spawnSet.selectedWeapon = player:GetActiveWeapon():GetClass()
    end

    if playersSets[player:SteamID()] then
        playersSets[player:SteamID()]:add(spawnSet)
    end
end)